# 测试内容: 用户认证模块-标准协议认证模块
# 如何运行: ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb

# 这个"标准协议认证模块"是什么？可参考文档: 
# https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html
# 描述：此模块包含 OIDC、OAuth 2.0、SAML、CAS 标准协议的认证、获取令牌、检查令牌、登出等方法。其中发起认证的方法需要在前端使用，获取令牌、检查令牌等方法需要在后端使用。

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb"
require 'dotenv' # 载入环境变量文件
Dotenv.load('.env.test')

class TestAuthenticationClientProtocal < Minitest::Test

  def setup
    options = {
      appId: ENV["appId"],
      secret: ENV["appSecret"],
      appHost: ENV["appHost"],
      redirectUri: ENV["redirectUri"],
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(options)
  end

  # 【需手工测试】
  # 生成 OIDC 协议的用户登录链接
  # 用户可以通过此链接访问 Authing 的在线登录页面
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_buildAuthorizeUrl
  def test_buildAuthorizeUrl
    client_options = {
      appHost: ENV["appHost"],
      appId: ENV["appId"],
      redirectUri: ENV["redirectUri"],
      protocol: 'oidc',
    };
    client = AuthingRuby::AuthenticationClient.new(client_options)
    options = { 
      scope: 'openid profile offline_access',
    }
    url = client.buildAuthorizeUrl(options)
    puts url
    # 测试方法1：手工把输出的 url 粘贴到浏览器里访问，如果可以正常访问就是成功

    # 测试方法2：照搬 JS SDK 里 src/lib/authentication/AuthenticationClient.spec.ts 的测试
    # 把生成的 url 检查一下里面的参数（以下是 js 代码）
    # t.assert(url1Data.hostname === 'oidc1.authing.cn');
    # t.assert(url1Data.pathname === '/oidc/auth');
    # t.assert(typeof parseInt(url1Data.searchParams.get('nonce')) === 'number');
    # t.assert(typeof parseInt(url1Data.searchParams.get('state')) === 'number');
    # t.assert(
    # 	url1Data.searchParams.get('scope') === 'openid profile offline_access'
    # );
    # t.assert(url1Data.searchParams.get('client_id') === '9072248490655972');
    # t.assert(url1Data.searchParams.get('redirect_uri') === 'https://baidu.com');
    # t.assert(url1Data.searchParams.get('response_type') === 'code');
    # t.assert(url1Data.searchParams.get('prompt') === 'consent');
    # t.falsy(url1Data.searchParams.get('code_verifier'));
  end

  # 需手工测试
  # PKCE 场景使用示例
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_buildAuthorizeUrl_2
  def test_buildAuthorizeUrl_2
    client_options = {
      appHost: ENV["appHost"],
      appId: ENV["appId"],
      redirectUri: ENV["redirectUri"],
      protocol: 'oidc',
    }
    client = AuthingRuby::AuthenticationClient.new(client_options)

    # PKCE 场景使用示例
    # 生成一个 code_verifier
    codeChallenge = client.generateCodeChallenge()
    # 计算 code_verifier 的 SHA256 摘要
    codeChallengeDigest = client.getCodeChallengeDigest({ codeChallenge: codeChallenge, method: 'S256' })
    # 构造 OIDC 授权码 + PKCE 模式登录 URL
    url2 = client.buildAuthorizeUrl({ codeChallenge: codeChallengeDigest, codeChallengeMethod: 'S256' })
    puts url2
    # 测试方法同样是把 url2 复制粘贴到浏览器里访问
  end

  # 需手工测试
  # 测试 Code 换 Token
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_getAccessTokenByCode
  def test_getAccessTokenByCode
    # 第一步：ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_buildAuthorizeUrl
    # 登录

    # 比如登录成功后跳转到了这个 URL
    # http://localhost:3000/authing_callback?code=BRWx1zB95MSSi_n3ZeC0t_Rnpyx8-ZvG7Afq7A1pEWP&state=5119168221224539

    # 那么把 code 复制过来
    code = 'BRWx1zB95MSSi_n3ZeC0t_Rnpyx8-ZvG7Afq7A1pEWP' #【你需要填写这里】
    resp = @authenticationClient.getAccessTokenByCode(code);
    # 如果失败：（比如 secret 填写成了用户池密钥是错的，应该填应用密钥）
    # {"error":"invalid_client","error_description":"client authentication failed"}

    # 如果 code 第二次使用（也会失败）
    # {"error"=>"invalid_grant", "error_description"=>"grant request is invalid"}

    # 如果成功
    # {"access_token":"[省略]","expires_in":1209600,"id_token":"[省略]","scope":"openid profile","token_type":"Bearer"}
    json = JSON.parse(resp.body)
    # puts JSON.pretty_generate(json)

    assert(json.dig('access_token') != nil)
    assert(json.dig('expires_in') != nil)
    assert(json.dig('id_token') != nil)
    assert(json.dig('scope') != nil)
    assert(json.dig('token_type') != nil)
  end

  # Token 换用户信息
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_getUserInfoByAccessToken
  def test_getUserInfoByAccessToken
    # 1. 获得登录页面的 url，浏览器访问
    # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_buildAuthorizeUrl
    
    # 2. 登录并获得 code
    code = "IAf-hgTKExt7d3RtVT-vSSADeycotgqqa2omB6fRvUY"

    # 3. 用 code 换取 access token
    resp = @authenticationClient.getAccessTokenByCode(code);
    json = JSON.parse(resp.body)
    puts json
    access_token = json.dig('access_token')
    
    if access_token == nil
      puts json
    else
      # 4. token 获取用户信息 
      puts "accessToken 是 #{access_token}"
      userInfo = @authenticationClient.getUserInfoByAccessToken(access_token)
      userInfoJson = JSON.parse(userInfo.body)
      puts userInfoJson
      # {"sub"=>"608b9b52414bd3b71fad04ef", "birthdate"=>nil, "family_name"=>nil, "gender"=>"U", "given_name"=>nil, "locale"=>nil, "middle_name"=>nil, "name"=>nil, "nickname"=>nil, "picture"=>"https://files.authing.co/authing-console/default-user-avatar.png", "preferred_username"=>nil, "profile"=>nil, "updated_at"=>"2021-04-30T05:53:26.782Z", "website"=>nil, "zoneinfo"=>nil}
    end
  end

  # 为了获取 refresh token
  # 只有授权码模式和密码模式支持 Refresh Token。
  # 注意 ⚠️⚠️⚠️：使用授权码模式时必须在请求授权端点（/oidc/auth） 时携带 scope 参数，值必须包含 offline_access，还必须携带 prompt 参数，值必须为 consent。否则 Authing 不会返回任何 Refresh Token。
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_get_refreshTokenBuildAuthorizeUrl
  def test_get_refreshTokenBuildAuthorizeUrl
    client_options = {
      appHost: ENV["appHost"],
      appId: ENV["appId"],
      redirectUri: ENV["redirectUri"],
      protocol: 'oidc',
    };
    client = AuthingRuby::AuthenticationClient.new(client_options)
    options = { 
      scope: 'openid profile offline_access',
    }
    url = client.buildAuthorizeUrl(options)
    puts url
  end

  # 刷新 Access Token
  # 只有授权码模式和密码模式支持 Refresh Token。
  # https://docs.authing.cn/v2/guides/federation/oidc.html#%E5%88%B7%E6%96%B0-access-token
  # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_getNewAccessTokenByRefreshToken
  def test_getNewAccessTokenByRefreshToken
    # 1. 构建登录 url
    # ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_get_refreshTokenBuildAuthorizeUrl

    # 2. 登录并获得 code
    # code = "I54TSnkHhh6IXdPdN8UjMnOaGbmjR61rcKGxm3-neLk"

    # 3. 用 code 换取 token (包含 access token 和 refresh token)
    # resp = @authenticationClient.getAccessTokenByCode(code);
    # json = JSON.parse(resp.body)
    # puts json

    # 返回示例
    json = {"access_token"=>"[省略]", "expires_in"=>1209600, "id_token"=>"[省略]", "refresh_token"=>"H7jJXZBHYyhPjMObTzt0VdQz2pKwVCTxIqeCzGHrfPE", "scope"=>"openid profile offline_access", "token_type"=>"Bearer"}
    refresh_token = json['refresh_token']
    # puts refresh_token

    # 最后用 refresh token 调用方法
    response = @authenticationClient.getNewAccessTokenByRefreshToken(refresh_token)
    response_json = JSON.parse(response.body)
    puts response_json
    # {"access_token"=>"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImZ6S0U4TUlidkVkdl9Mb3N5a1dHTjdNTmpqbjlQMldvVmxtN0pIcFVZUFUifQ.eyJqdGkiOiJRYUF2ZU9ScUNlS3J0LVpPTWFRSVYiLCJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJpYXQiOjE2MTk3ODE2NDYsImV4cCI6MTYyMDk5MTI0Niwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyIsImlzcyI6Imh0dHBzOi8vcmFpbHMtZGVtby5hdXRoaW5nLmNuL29pZGMiLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIifQ.WNwR3yOx4XoPU-xGwPxPDlJI7V-EZ6aKwxk5tPg1bpfhhxkMW-o6mJU4_n7ZCMSeXJqikD0e5phGkg79brawGCkmBfW6khS5d5xCiPJg20Ru7NQZMVBTrsislnXIZn18cSrZz8MeDLOQTYCNW686Uz-D0eJu_JTeocjijHq3uwZX_5YR7yOgl2lbjZ2jo1zpbtkCrNHMO3HXVvv1zpNFLg6e11u5xFjGq_HugEvbeL-YSCT9g83_C0IAqg-letoJTWxUkWkxlPWrVAnv9KIjPuGaynQTYc0GEuvASt58uS1dzRRQ73G2x5fKHfX8E-0qyuqfsRr5_CpjIlLHMt2c8Q", "expires_in"=>1209600, "id_token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNC0zMFQwNTo1MzoyNi43ODJaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsIm5vbmNlIjoiNDc1MzQ0NDcyNDczODA5MCIsImF0X2hhc2giOiJMUE90dlpiR2lBSjMzanJ5OW9GQ2t3IiwiYXVkIjoiNjA4MDBiOTE1MWQwNDBhZjkwMTZkNjBiIiwiZXhwIjoxNjIwOTkxMjQ2LCJpYXQiOjE2MTk3ODE2NDYsImlzcyI6Imh0dHBzOi8vcmFpbHMtZGVtby5hdXRoaW5nLmNuL29pZGMifQ.u44mKaDN_zAEBuoIXcXH9Nfxx6HSwOzduu5TtOR18VQ", "refresh_token"=>"H7jJXZBHYyhPjMObTzt0VdQz2pKwVCTxIqeCzGHrfPE", "scope"=>"openid profile offline_access", "token_type"=>"Bearer"}
  end

end