require_relative './BaseAuthenticationClient.rb'
require 'jwt'
require 'uri/query_params'
require 'digest'
require "base64"

module AuthingRuby
  class AuthenticationClient
    def initialize(options = {})
      @options = options

      @appId = options.fetch(:appId, nil) # 应用 ID
      @secret = options.fetch(:secret, nil) # 应用密钥
      @appHost = options.fetch(:appHost, nil) # 该应用的域名
      @redirectUri = options.fetch(:redirectUri, nil) # 业务回调地址
      @protocol = options.fetch(:protocol, 'oidc') # 协议类型，可选值为 oidc、oauth、saml、cas

      # 公钥加密
      @publicKeyManager = AuthingRuby::Common::PublicKeyManager.new(options)

      # 负责发送 GraphQL (其实就是 http) 请求的工具
      graphqlEndpoint = "#{@appHost}/graphql/v2"
      @graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlEndpoint, @options)
      
      # tokenProvider 只是存取一下 user 和 token
      @tokenProvider = Authentication::AuthenticationTokenProvider.new()

      @httpClient = AuthingRuby::Common::HttpClient.new(options, @tokenProvider)
      @naiveHttpClient = AuthingRuby::Common::NaiveHttpClient.new(options, @tokenProvider)

      # 把 GraphQL 文件夹路径放这里, 这些是私有变量
      @folder_graphql = "./lib/graphql"
      @folder_graphql_mutation = "#{@folder_graphql}/mutations"
      @folder_graphql_query = "#{@folder_graphql}/queries"

      @baseClient = Authentication::BaseAuthenticationClient.new(options)

      # 以下几个参数主要用于 "标准协议认证模块"
      @tokenEndPointAuthMethod = options.fetch(:tokenEndPointAuthMethod, 'client_secret_post')
      @introspectionEndPointAuthMethod = options.fetch(:introspectionEndPointAuthMethod, 'client_secret_post')
      @revocationEndPointAuthMethod = options.fetch(:revocationEndPointAuthMethod, 'client_secret_post')

      token = options.fetch(:token, nil)
      if token
        setToken(token)
      end
    end

    # 使用邮箱+密码注册 (完成, 测试通过)
    # 参照: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html
    # 测试代码: 
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.registerByEmail('301@qq.com', "123456789")
    def registerByEmail(email, password, profile = {}, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "email": email,
          "password": encryptedPassword,

          "profile": profile,
          "forceLogin": options.fetch(:forceLogin, false),
          "clientIp": options.fetch(:clientIp, nil),
          "context": options.fetch(:context, nil),
          "generateToken": options.fetch(:generateToken, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.registerByEmail(@graphqlClient, variables)
      user = hash.dig('data', 'registerByEmail')
      return user if user
      return hash
    end

    # 使用用户名注册
    # https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E4%BD%BF%E7%94%A8%E7%94%A8%E6%88%B7%E5%90%8D%E6%B3%A8%E5%86%8C
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.registerByUsername('agoodob', "123456789")
    def registerByUsername(username, password, profile = {}, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "username": username,
          "password": encryptedPassword,

          "profile": profile,
          "forceLogin": options.fetch(:forceLogin, false),
          "clientIp": options.fetch(:clientIp, nil),
          "context": options.fetch(:context, nil),
          "generateToken": options.fetch(:generateToken, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.registerByUsername(@graphqlClient, variables)
      user = hash.dig('data', 'registerByUsername')
      return user if user
      return hash
    end

    # 发送短信验证码
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b", userPoolId: "60800b8ee5b66b23128b4980"})
    # a.sendSmsCode("13556136684")
    def sendSmsCode(phone)
      url = "#{@appHost}/api/v2/sms/send"
      graphqlClient = AuthingRuby::Common::GraphqlClient.new(url, @options)
      json = {
        "phone": phone
      }
      response = graphqlClient.request({json: json})
      # {"code":200,"message":"发送成功"}
      return response
    end

    # 使用手机号注册
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b", userPoolId: "60800b8ee5b66b23128b4980"})
    # a.registerByPhoneCode("13556136684", "6330", "123456")
    def registerByPhoneCode(phone, code, password, profile = {}, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "phone": phone,
          "code": code,
          "password": encryptedPassword,

          "profile": profile,
          "forceLogin": options.fetch(:forceLogin, false),
          "clientIp": options.fetch(:clientIp, nil),
          "context": options.fetch(:context, nil),
          "generateToken": options.fetch(:generateToken, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.registerByPhoneCode(@graphqlClient, variables)
      user = hash.dig('data', 'registerByPhoneCode')
      return user if user
      return hash
    end

    # 使用邮箱登录
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b", userPoolId: "60800b8ee5b66b23128b4980"})
    # a.loginByEmail('301@qq.com', "123456789")
    def loginByEmail(email, password, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "email": email,
          "password": encryptedPassword,

          "autoRegister": options.fetch(:autoRegister, nil),
          "captchaCode": options.fetch(:captchaCode, nil),
          "clientIp": options.fetch(:clientIp, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.loginByEmail(@graphqlClient, variables)
      user = hash.dig('data', 'loginByEmail')
      if user
        setCurrentUser(user);
        return user 
      end
      return hash
    end

    # 使用用户名登录
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.loginByUsername('agoodob', "123456789")
    def loginByUsername(username, password, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "username": username,
          "password": encryptedPassword,

          "autoRegister": options.fetch(:autoRegister, nil),
          "captchaCode": options.fetch(:captchaCode, nil),
          "clientIp": options.fetch(:clientIp, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.loginByUsername(@graphqlClient, variables)
      user = hash.dig('data', 'loginByUsername')
      if user
        setCurrentUser(user);
        return user 
      end
      return hash
    end

    # 使用手机号验证码登录
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.sendSmsCode("13556136684")
    # a.loginByPhoneCode("13556136684", "1347")
    def loginByPhoneCode(phone, code, options = {})
      # 第一步：构建 variables
      variables = {
        "input": {
          "phone": phone,
          "code": code,
          "clientIp": options.fetch(:clientIp, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.loginByPhoneCode(@graphqlClient, variables)
      user = hash.dig('data', 'loginByPhoneCode')
      if user
        setCurrentUser(user);
        return user 
      end
      return hash
    end

    # 使用手机号密码登录
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.loginByPhonePassword("13556136684", "123456")
    def loginByPhonePassword(phone, password, options = {})
      # 第一步：构建 variables
      publicKey = @publicKeyManager.getPublicKey()
      encryptedPassword = AuthingRuby::Utils.encrypt(password, publicKey)
      variables = {
        "input": {
          "phone": phone,
          "password": encryptedPassword,

          "captchaCode": options.fetch(:captchaCode, nil),
          "clientIp": options.fetch(:clientIp, nil),
        }
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.loginByPhonePassword(@graphqlClient, variables)
      user = hash.dig('data', 'loginByPhonePassword')
      if user
        setCurrentUser(user);
        return user 
      end
      return hash
    end

    # 发送邮件
    # a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
    # a.sendEmail('guokrfans@gmail.com', "VERIFY_EMAIL")
    # * @param {EmailScene} scene 发送场景，可选值为 RESET_PASSWORD（发送重置密码邮件，邮件中包含验证码）、VerifyEmail（发送验证邮箱的邮件）、ChangeEmail（发送修改邮箱邮件，邮件中包含验证码）
    def sendEmail(email, scene)
      variables = {
        "email": email,
        "scene": scene,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.sendEmail(@graphqlClient, variables)
      data = hash.dig('data')
      return data if data
      return hash
      # {"sendEmail":{"message":"","code":200}}
    end

    # 获取当前登录的用户信息
    # 返回：用户信息
    def getCurrentUser()
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.getCurrentUser(@graphqlClient, @tokenProvider, {})
      user = hash.dig("data", "user")
      if user
        setCurrentUser(user)
        return user
      else
        return hash
      end
    end

    def setCurrentUser(user)
      @tokenProvider.setUser(user);
    end

    def setToken(token)
      @tokenProvider.setToken(token);
    end

    # 退出登录
    def logout()
      url = "#{@appHost}/api/v2/logout?app_id=#{@appId}"
      @httpClient.request({
        method: 'GET',
        url: url,
      });
      @tokenProvider.clearUser();
    end

    # 私有函数，用于 buildAuthorizeUrl 处理 OIDC 协议
    # 写法是完全参照的 JS SDK
    def _buildOidcAuthorizeUrl(options = {})
      # 名字的映射
      map = {
        appId: 'client_id',
        scope: 'scope',
        state: 'state',
        nonce: 'nonce',
        responseMode: 'response_mode',
        responseType: 'response_type',
        redirectUri: 'redirect_uri',
        codeChallenge: 'code_challenge',
        codeChallengeMethod: 'code_challenge_method'
      };
      # 用来构造 url
      res = {
        nonce: AuthingRuby::Utils.randomNumberString(16),
        state: AuthingRuby::Utils.randomNumberString(16),
        scope: 'openid profile email phone address',
        client_id: @appId,
        redirect_uri: @redirectUri,
        response_type: 'code',
      };

      map.each do |key, value|
        if options[key.to_sym]
          # 如果 scope 的值里有 offline_access
          if value == 'scope' && options.fetch(:scope, []).split(' ').include?("offline_access")
            res[:prompt] = 'consent'
          end
          res[value.to_sym] = options[key]
        end
      end

      authorizeUrl = @baseClient.appHost + '/oidc/auth?' + URI::QueryParams.dump(res)
      return authorizeUrl
    end

    # TODO
    # 生成 OIDC 协议的用户登录链接
    # 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#%E7%94%9F%E6%88%90-oidc-%E5%8D%8F%E8%AE%AE%E7%9A%84%E7%94%A8%E6%88%B7%E7%99%BB%E5%BD%95%E9%93%BE%E6%8E%A5
    # 代码: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2098
    def buildAuthorizeUrl(options = {})
      unless @appHost
        raise '请在初始化 AuthenticationClient 时传入应用域名 appHost 参数，形如：https://app1.authing.cn'
      end
      protocol = @options.fetch(:protocol, nil)
      if protocol == 'oidc'
        return _buildOidcAuthorizeUrl(options);
      end
      if protocol == 'oauth'
        throw "oauth 协议暂未实现"
      end
      if protocol == 'saml'
        throw "saml 协议暂未实现"
      end
      if protocol == 'cas'
        throw "cas 协议暂未实现"
      end
      raise '不支持的协议类型，请在初始化 AuthenticationClient 时传入 protocol 参数，可选值为 oidc、oauth、saml、cas'
    end

    # 逻辑参照 JS SDK
    # 目的: 把 params 这个 hash 里 value 为空的值全部删掉
    # 最后返回一个 url params 字符串
    def _generateTokenRequest(params)
      ret = {}
      params.each do |key, value|
        if value
          ret[key] = value
        end
      end
      return URI::QueryParams.dump(ret)
    end

    def _getAccessTokenByCodeWithClientSecretPost(code, options = {})
      codeVerifier = options.fetch(:codeVerifier, nil)
      qstr = _generateTokenRequest({
        client_id: @appId,
        client_secret: @secret,
        grant_type: 'authorization_code',
        code: code,
        redirect_uri: @redirectUri,
        code_verifier: codeVerifier,
      })

      api = ''
      if @protocol == 'oidc'
        api = "#{@baseClient.appHost}/oidc/token"
      elsif @protocol == 'oauth'
        api = "#{@baseClient.appHost}/oauth/token"
      end
      tokenSet = @naiveHttpClient.request({
        method: 'POST',
        url: api,
        data: qstr,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      })
      return tokenSet
    end

    # Code 换 Token
    # 使用授权码 Code 获取用户的 Token 信息。
    # res = a.getAccessTokenByCode('授权码 code');
    # 参照: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L1977
    def getAccessTokenByCode(code, options = {})
      # 检查参数合法性
      if ['oauth', 'oidc'].include?(@protocol) == false
        raise '初始化 AuthenticationClient 时传入的 protocol 参数必须为 oauth 或 oidc，请检查参数'
      end
      if !@secret && @tokenEndPointAuthMethod != nil
        raise '请在初始化 AuthenticationClient 时传入 appId 和 secret 参数'
      end

      if @tokenEndPointAuthMethod == 'client_secret_post'
        return _getAccessTokenByCodeWithClientSecretPost(code, options)
      end

      if @tokenEndPointAuthMethod == 'client_secret_basic'
        # TODO
        raise "client_secret_basic 还未实现"
        # return _getAccessTokenByCodeWithClientSecretBasic(code, options.fetch(:codeVerifier, nil))
      end

      if @tokenEndPointAuthMethod == nil
        # TODO
        raise "还未实现"
        # return _getAccessTokenByCodeWithNone(code, options.fetch(:codeVerifier, nil))
      end
    end

    # Token 换用户信息
    # 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#token-%E6%8D%A2%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF
    # 参考: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2082
    def getUserInfoByAccessToken(access_token)
      api = nil;
      if @protocol == 'oidc'
        api = "#{@appHost}/oidc/me";
      elsif @protocol == 'oauth'
        api = "#{@appHost}/oauth/me";
      end

      userInfo = @naiveHttpClient.request({
        method: 'POST',
        url: api,
        headers: {
          Authorization: 'Bearer ' + access_token
        }
      });
      return userInfo
    end

    def _getNewAccessTokenByRefreshTokenWithClientSecretPost(refreshToken)
        qstr = _generateTokenRequest({
          client_id: @appId,
          client_secret: @secret,
          grant_type: 'refresh_token',
          refresh_token: refreshToken
        });

        api = ''
        if @protocol == 'oidc'
          api = "#{@baseClient.appHost}/oidc/token"
        elsif @protocol == 'oauth'
          api = "#{@baseClient.appHost}/oauth/token"
        end

        tokenSet = @naiveHttpClient.request({
          method: 'POST',
          url: api,
          data: qstr,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        });
        return tokenSet;
    end

    # TODO
    # 刷新 Access Token
    # 使用 Refresh token 获取新的 Access token。
    # 代码参考: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2296
    def getNewAccessTokenByRefreshToken(refreshToken)
      # 检查参数合法性
      if ['oauth', 'oidc'].include?(@protocol) == false
        raise '初始化 AuthenticationClient 时传入的 protocol 参数必须为 oauth 或 oidc，请检查参数'
      end
      if !@secret && @tokenEndPointAuthMethod != nil
        raise '请在初始化 AuthenticationClient 时传入 appId 和 secret 参数'
      end

      if @tokenEndPointAuthMethod == 'client_secret_post'
        return _getNewAccessTokenByRefreshTokenWithClientSecretPost(
          refreshToken
        );
      end
      if @tokenEndPointAuthMethod == 'client_secret_basic'
        # return await this._getNewAccessTokenByRefreshTokenWithClientSecretBasic(
        #   refreshToken
        # );
      end
      if @tokenEndPointAuthMethod == 'none'
        # return await this._getNewAccessTokenByRefreshTokenWithNone(refreshToken);
      end
    end

    def _introspectTokenWithClientSecretPost(token)
      qstr = _generateTokenRequest({
        client_id: @appId,
        client_secret: @secret,
        token: token,
      })
      api = ''
      if @protocol == 'oidc'
        api = "#{@baseClient.appHost}/oidc/token/introspection"
      elsif @protocol == 'oauth'
        api = "#{@baseClient.appHost}/oauth/token/introspection"
      end
      tokenSet = @naiveHttpClient.request({
        method: 'POST',
        url: api,
        data: qstr,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
      return tokenSet;
    end

    # TODO
    # 检查 Access Token 或 Refresh token 的状态
    # 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#%E6%A3%80%E6%9F%A5-access-token
    # 代码参考: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2479
    def introspectToken(token)
      # 检查参数合法性
      if ['oauth', 'oidc'].include?(@protocol) == false
        raise '初始化 AuthenticationClient 时传入的 protocol 参数必须为 oauth 或 oidc，请检查参数'
      end
      if !@secret && @tokenEndPointAuthMethod != nil
        raise '请在初始化 AuthenticationClient 时传入 appId 和 secret 参数'
      end

      if @introspectionEndPointAuthMethod == 'client_secret_post'
        return _introspectTokenWithClientSecretPost(token)
      end
      if @introspectionEndPointAuthMethod == 'client_secret_basic'
        # return await this._introspectTokenWithClientSecretBasic(token);
      end
      if @introspectionEndPointAuthMethod == 'none'
        # return await this._introspectTokenWithNone(token);
      end
      raise '初始化 AuthenticationClient 时传入的 introspectionEndPointAuthMethod 参数可选值为 client_secret_base、client_secret_post、none，请检查参数'
    end

    # TODO
    # 检验 Id Token 合法性
    # 通过 Authing 提供的在线接口验证 Id token 或 Access token。会产生网络请求。
    # 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#%E6%A3%80%E9%AA%8C-id-token-%E5%90%88%E6%B3%95%E6%80%A7
    # 代码参考: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2582
    def validateToken(options = {})
      if options.empty?
        raise '请在传入的参数对象中包含 accessToken 或 idToken 字段'
      end

      accessToken = options.fetch(:accessToken, nil)
      idToken = options.fetch(:idToken, nil)

      if accessToken != nil && idToken != nil
        raise "accessToken 和 idToken 只能传入一个，不能同时传入"
      end

      if idToken
        data = @naiveHttpClient.request({
          url: "#{@baseClient.appHost}/api/v2/oidc/validate_token",
          method: 'GET',
          params: {
            id_token: idToken
          }
        })
        return data
      elsif accessToken
        data = @naiveHttpClient.request({
          url: "#{@baseClient.appHost}/api/v2/oidc/validate_token",
          method: 'GET',
          params: {
            access_token: accessToken
          }
        });
        return data
      end
    end

    # 修改用户资料
    def updateProfile(updates = {})
      userId = checkLoggedIn()
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "id": userId,
        "input": updates
      }
      hash = graphqlAPI.updateUser(@graphqlClient, @tokenProvider, variables)
      updated_user = hash.dig('data', 'updateUser')
      if updated_user
        # 如果更新成功，返回更新后的用户
        setCurrentUser(updated_user)
        return updated_user
      else
        # 如果更新失败，返回原结果
        # {"errors"=>[{"message"=>{"code"=>2020, "message"=>"尚未登录，无访问权限"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["updateUser"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>nil}
        return hash
      end
    end

    # checkLoggedIn 解释: 
    # 如果登录了，会返回唯一 id (userId)
    # 如果没登录，会抛出错误
    def checkLoggedIn()
      # 有 user 就直接返回 id
      user = @tokenProvider.getUser()
      if user
        return user.fetch("id", nil) # 608966b08b4af522620d2e59
      end
  
      # 尝试获取 token
      token = @tokenProvider.getToken()
      if !token
        raise '请先登录!' # 例子: 如果 logout 了再次调用 checkLoggedIn 会报错，就是这里报错
      end

      # 解码 token
      decoded_token_array = JWT.decode token, nil, false
      payload = decoded_token_array[0]

      # 从 token 中获取 user_id 并返回
      userId = nil
      authing_sub = payload.fetch("sub", nil)
      id = payload.dig("data", "id")

      if authing_sub
        userId = authing_sub
      else
        userId = id
      end

      return userId
    end

    # 检查密码强度
    def checkPasswordStrength(password)
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = { "password": password }
      hash = graphqlAPI.checkPasswordStrength(@graphqlClient, @tokenProvider, variables)
      return hash.dig("data", "checkPasswordStrength")
    end

    # 检测 Token 登录状态
    def checkLoginStatus(token)
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = { "token": token }
      hash = graphqlAPI.checkLoginStatus(@graphqlClient, @tokenProvider, variables)
      return hash.dig("data", "checkLoginStatus")
    end

    # 更新用户密码
    def updatePassword(newPassword, oldPassword)
      publicKey = @publicKeyManager.getPublicKey()
      newPasswordEncrypted = AuthingRuby::Utils.encrypt(newPassword, publicKey)
      oldPasswordEncrypted = AuthingRuby::Utils.encrypt(oldPassword, publicKey)
      variables = { 
        "newPassword": newPasswordEncrypted,
        "oldPassword": oldPasswordEncrypted,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.updatePassword(@graphqlClient, @tokenProvider, variables)
      return hash.dig("data", "updatePassword")
    end

    # 绑定手机号
    # 用户初次绑定手机号，如果需要修改手机号请使用 updatePhone 方法。如果该手机号已被绑定，将会绑定失败。发送验证码请使用 sendSmsCode 方法。
    def bindPhone(phone, phoneCode)
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "phone": phone,
        "phoneCode": phoneCode,
      }
      hash = graphqlAPI.bindPhone(@graphqlClient, @tokenProvider, variables)
      user = hash.dig("data", "bindPhone")
      if user
        setCurrentUser(user);
        return user;
      else
        return hash
      end
    end

    # 更新用户手机号
    # 更新用户手机号。和修改邮箱一样，默认情况下，如果用户当前已经绑定了手机号，需要同时验证原有手机号（目前账号绑定的手机号）和当前邮箱（将要绑定的手机号）。
    # 也就是说，用户 A 当前绑定的手机号为 15888888888，想修改为 15899999999，那么就需要同时验证这两个手机号。
    # 开发者也可以选择不开启 “验证原有手机号“ ，可以在 Authing 控制台 的 设置目录下的安全信息模块进行关闭。
    # 用户首次绑定手机号请使用 bindPhone 接口。
    def updatePhone(phone, phoneCode, oldPhone, oldPhoneCode)
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "phone": phone,
        "phoneCode": phoneCode,
      }
      variables['oldPhone'] = oldPhone if oldPhone
      variables['oldPhoneCode'] = oldPhoneCode if oldPhoneCode

      hash = graphqlAPI.updatePhone(@graphqlClient, @tokenProvider, variables)
      user = hash.dig("data", "updatePhone")
      if user
        setCurrentUser(user)
        return user
      else
        return hash
      end
    end

    # 通过短信验证码重置密码
    def resetPasswordByPhoneCode(phone, code, newPassword)
      publicKey = @publicKeyManager.getPublicKey()
      newPasswordEncrypted = AuthingRuby::Utils.encrypt(newPassword, publicKey)

      variables = {
        "phone": phone,
        "code": code,
        "newPassword": newPasswordEncrypted,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      hash = graphqlAPI.resetPassword(@graphqlClient, @tokenProvider, variables)
      result = hash.dig("data", "resetPassword") # {"message":"重置密码成功！","code":200}
      return result if result
      return hash
    end

    def generateCodeChallenge()
      return AuthingRuby::Utils.generateRandomString(43);
    end

    # 照搬 JS SDK 的逻辑
    def getCodeChallengeDigest(options = {})
      if options.empty?
        raise '请提供 options 参数，options.codeChallenge 为一个长度大于等于 43 的字符串，options.method 可选值为 S256、plain'
      end
      codeChallenge = options.fetch(:codeChallenge, nil)
      method = options.fetch(:method, 'S256')

      if codeChallenge == nil
        raise '请提供 options.codeChallenge，值为一个长度大于等于 43 的字符串'
      end

      if method == 'S256'
        base64 = Digest::SHA256.base64digest codeChallenge
        result = base64.gsub(/\+/, '-').gsub(/\//, '-').gsub(/=/, '')
        return result
      end
      if method == 'plain'
        return options.codeChallenge;
      end
      raise '不支持的 options.method，可选值为 S256、plain'
    end

    def _revokeTokenWithClientSecretPost(token)
      qstr = _generateTokenRequest({
        client_id: @appId,
        client_secret: @secret,
        token: token,
      });
      api = '';
      if @protocol === 'oidc'
        api = "#{@baseClient.appHost}/oidc/token/revocation";
      elsif @protocol === 'oauth'
        api = "#{@baseClient.appHost}/oauth/token/revocation";
      end
      tokenSet = @naiveHttpClient.request({
        method: 'POST',
        url: api,
        data: qstr,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
      return tokenSet;
    end

    # 撤回 Access Token 或 Refresh token
    def revokeToken(token)
      # 检查参数合法性
      if ['oauth', 'oidc'].include?(@protocol) == false
        raise '初始化 AuthenticationClient 时传入的 protocol 参数必须为 oauth 或 oidc，请检查参数'
      end
      if !@secret && @tokenEndPointAuthMethod != nil
        raise '请在初始化 AuthenticationClient 时传入 appId 和 secret 参数'
      end

      if @revocationEndPointAuthMethod == 'client_secret_post'
        _revokeTokenWithClientSecretPost(token) # 实测这个请求啥也不返回, 空的, 所以把这个直接 return 返回没啥用
        return true;
      end
      if @revocationEndPointAuthMethod == 'client_secret_basic'
        # await this._revokeTokenWithClientSecretBasic(token);
        # return true;
      end
      if @revocationEndPointAuthMethod == 'none'
        # await this._revokeTokenWithNone(token);
        # return true;
      end
      raise '初始化 AuthenticationClient 时传入的 revocationEndPointAuthMethod 参数可选值为 client_secret_base、client_secret_post、none，请检查参数'
    end

  end
end