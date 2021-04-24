require './lib/authentication/BaseAuthenticationClient.rb'

module AuthingRuby
	class AuthenticationClient
		def initialize(options = {})
			@options = options

			@appId = options.fetch(:appId, nil) # 应用 ID
			@secret = options.fetch(:secret, nil) # 应用密钥
			@appHost = options.fetch(:appHost, nil) # 该应用的域名
			@redirectUri = options.fetch(:redirectUri, nil) # 业务回调地址
			@protocol = options.fetch(:protocol, nil) # 协议类型，可选值为 oidc、oauth、saml、cas

			# 公钥加密
			@publicKeyManager = Common::PublicKeyManager.new(options)

			# 负责发送 GraphQL (其实就是 http) 请求的工具
			graphqlEndpoint = "#{@appHost}/graphql/v2";
			@graphqlClient = Common::GraphqlClient.new(graphqlEndpoint, @options)
			
			# tokenProvider 只是存取一下 user 和 token
			@tokenProvider = Authentication::AuthenticationTokenProvider.new()

			# @httpClient = HttpClient

			# 把 GraphQL 文件夹路径放这里, 这些是私有变量
			@folder_graphql = "./lib/graphql"
			@folder_graphql_mutation = "#{@folder_graphql}/mutations"
			@folder_graphql_query = "#{@folder_graphql}/queries"

			# @baseClient = Authentication::BaseAuthenticationClient.new(options)
		end

		# 使用邮箱+密码注册 (完成, 测试通过)
		# 参照: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html
		# 测试代码: 
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.registerByEmail('301@qq.com', "123456789")
		def registerByEmail(email, password, profile = {}, options = {})
			# 第一步：构建 variables
			publicKey = @publicKeyManager.getPublicKey()
			encryptedPassword = Utils.encrypt(password, publicKey)
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
			# 第二步：构建 payload
			file = File.open("#{@folder_graphql_mutation}/registerByEmail.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})
			return response
		end

		# 使用用户名注册
		# https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E4%BD%BF%E7%94%A8%E7%94%A8%E6%88%B7%E5%90%8D%E6%B3%A8%E5%86%8C
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.registerByUsername('agoodob', "123456789")
		def registerByUsername(username, password, profile = {}, options = {})
			# 第一步：构建 variables
			publicKey = @publicKeyManager.getPublicKey()
			encryptedPassword = Utils.encrypt(password, publicKey)
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
			# 第二步：构建 payload
			file = File.open("#{@folder_graphql_mutation}/registerByUsername.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})
			return response
		end

		# 发送短信验证码
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b", userPoolId: "60800b8ee5b66b23128b4980"})
		# a.sendSmsCode("13556136684")
		def sendSmsCode(phone)
			url = "#{@appHost}/api/v2/sms/send"
			graphqlClient = Common::GraphqlClient.new(url, @options)
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
			encryptedPassword = Utils.encrypt(password, publicKey)
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
			# 第二步：构建整个 payload
			file = File.open("#{@folder_graphql_mutation}/registerByPhoneCode.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})
			return response
		end

		# 使用邮箱登录
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b", userPoolId: "60800b8ee5b66b23128b4980"})
		# a.loginByEmail('301@qq.com', "123456789")
		def loginByEmail(email, password, options = {})
			# 第一步：构建 variables
			publicKey = @publicKeyManager.getPublicKey()
			encryptedPassword = Utils.encrypt(password, publicKey)
			variables = {
				"input": {
					"email": email,
					"password": encryptedPassword,

					"autoRegister": options.fetch(:autoRegister, nil),
					"captchaCode": options.fetch(:captchaCode, nil),
					"clientIp": options.fetch(:clientIp, nil),
				}
			}
			# 第二步：构建整个 payload
			file = File.open("#{@folder_graphql_mutation}/loginByEmail.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})

			# 第四步：把结果存起来
			json = JSON.parse(response)
			user = json['data']['loginByEmail']
			setCurrentUser(user);

			return response
		end

		# 使用用户名登录
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.loginByUsername('agoodob', "123456789")
		def loginByUsername(username, password, options = {})
			# 第一步：构建 variables
			publicKey = @publicKeyManager.getPublicKey()
			encryptedPassword = Utils.encrypt(password, publicKey)
			variables = {
				"input": {
					"username": username,
					"password": encryptedPassword,

					"autoRegister": options.fetch(:autoRegister, nil),
					"captchaCode": options.fetch(:captchaCode, nil),
					"clientIp": options.fetch(:clientIp, nil),
				}
			}
			# 第二步：构建整个 payload
			file = File.open("#{@folder_graphql_mutation}/loginByUsername.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})

			# 第四步：把结果存起来
			json = JSON.parse(response)
			user = json['data']['loginByUsername']
			setCurrentUser(user);

			return response
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
			# 第二步：构建 payload
			file = File.open("#{@folder_graphql_mutation}/loginByPhoneCode.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})

			# 第四步：把结果存起来
			json = JSON.parse(response)
			user = json['data']['loginByPhoneCode']
			setCurrentUser(user);

			return response
		end

		# 使用手机号密码登录
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.loginByPhonePassword("13556136684", "123456")
		def loginByPhonePassword(phone, password, options = {})
			# 第一步：构建 variables
			publicKey = @publicKeyManager.getPublicKey()
			encryptedPassword = Utils.encrypt(password, publicKey)
			variables = {
				"input": {
					"phone": phone,
					"password": encryptedPassword,

					"captchaCode": options.fetch(:captchaCode, nil),
					"clientIp": options.fetch(:clientIp, nil),
				}
			}
			# 第二步：构建 payload
			file = File.open("#{@folder_graphql_mutation}/loginByPhonePassword.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})

			# 第四步：把结果存起来
			json = JSON.parse(response)
			user = json['data']['loginByPhonePassword']
			setCurrentUser(user);

			return response
		end

		def checkLoginStatus
		end

		# 发送邮件
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.sendEmail('guokrfans@gmail.com', "VERIFY_EMAIL")
		# * @param {EmailScene} scene 发送场景，可选值为 RESET_PASSWORD（发送重置密码邮件，邮件中包含验证码）、VerifyEmail（发送验证邮箱的邮件）、ChangeEmail（发送修改邮箱邮件，邮件中包含验证码）
		def sendEmail(email, scene)
			# 第一步：构建 variables
			variables = {
				"email": email,
				"scene": scene,
			}
			# 第二步：构建 payload
			file = File.open("#{@folder_graphql_mutation}/sendEmail.gql")
			json = {
				"query": file.read,
				"variables": variables,
			}
			# 第三步：发请求
			response = @graphqlClient.request({json: json})
			return response
			# {"data":{"sendEmail":{"message":"","code":200}}}
		end

		# 获取当前登录的用户信息
		# a = AuthingRuby::AuthenticationClient.new({appHost: "https://rails-demo.authing.cn", appId: "60800b9151d040af9016d60b"})
		# a.loginByUsername('agoodob', "123456789")
		# a.getCurrentUser()
		def getCurrentUser()
			file = File.open("#{@folder_graphql_query}/user.gql")
			json = {
				"query": file.read
			}
			token = @tokenProvider.getToken();
			# 第三步：发请求
			response = @graphqlClient.request({json: json, token: token})
			json = JSON.parse(response)
			setCurrentUser(json['data']['user'])
			return response
		end

		def setCurrentUser(user)
			@tokenProvider.setUser(user);
		end

		def setToken(token)
			@tokenProvider.setToken(token);
		end

		# a.testGetUser()
		# def testGetUser()
		#   @tokenProvider.getUser();
		# end

		# 退出登录
		# TODO
		def logout()
			# await this.httpClient.request({
			#   method: 'GET',
			#   url: ,
			#   withCredentials: true
			# });
			# resp = HTTP.get("#{@appHost}/api/v2/logout?app_id=#{@appId}")
			@tokenProvider.clearUser();
		end

		# 私有函数，用于 buildAuthorizeUrl 处理 OIDC 协议
		def _buildOidcAuthorizeUrl(options = {})
			# TODO
=begin
			let map: any = {
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
			let res: any = {
				nonce: Math.random()
					.toString()
					.slice(2),
				state: Math.random()
					.toString()
					.slice(2),
				scope: 'openid profile email phone address',
				client_id: this.options.appId,
				redirect_uri: this.options.redirectUri,
				response_type: 'code'
			};
			Object.keys(map).forEach(k => {
				if (options && (options as any)[k]) {
					if (k === 'scope' && options.scope.includes('offline_access')) {
						res.prompt = 'consent';
					}
					res[map[k]] = (options as any)[k];
				}
			});
			let params = new URLSearchParams(res);
			let authorizeUrl =
				this.baseClient.appHost + '/oidc/auth?' + params.toString();
			return authorizeUrl;
=end
		end

		# 生成 OIDC 协议的用户登录链接
		# 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#%E7%94%9F%E6%88%90-oidc-%E5%8D%8F%E8%AE%AE%E7%9A%84%E7%94%A8%E6%88%B7%E7%99%BB%E5%BD%95%E9%93%BE%E6%8E%A5
		# 代码: https://github.com/Authing/authing.js/blob/cf4757d09de3b44c3c3f4509ae8c8715c9f302a2/src/lib/authentication/AuthenticationClient.ts#L2098
		def buildAuthorizeUrl(options = {})
			unless @appHost
				throw '请在初始化 AuthenticationClient 时传入应用域名 appHost 参数，形如：https://app1.authing.cn'
			end
			protocol = options.fetch(:protocol, nil)
			if protocol === 'oidc'
				return _buildOidcAuthorizeUrl(options);
			end
			if protocol === 'oauth'
				throw "oauth 协议暂未实现"
			end
			if protocol === 'saml'
				throw "saml 协议暂未实现"
			end
			if protocol === 'cas'
				throw "cas 协议暂未实现"
			end
			throw '不支持的协议类型，请在初始化 AuthenticationClient 时传入 protocol 参数，可选值为 oidc、oauth、saml、cas'
		end

	end
end