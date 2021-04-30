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

	# 测试初始化
	# ruby ./lib/test/mini_test/TestAuthenticationClientProtocal.rb -n test_init
	def test_init
    options = {
      appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      appId: ENV["appId"], # "60800b9151d040af9016d60b"
			secret: ENV["secret"],
			redirectUri: ENV["redirectUri"],
    }
		AuthingRuby::AuthenticationClient.new(options)
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
		client_options = {
      appId: ENV["appId"],
      secret: ENV["appSecret"],
      appHost: ENV["appHost"],
			redirectUri: ENV["redirectUri"],
		}
		client = AuthingRuby::AuthenticationClient.new(client_options)

		# 比如登录成功后跳转到了这个 URL
		# http://localhost:3000/authing_callback?code=BRWx1zB95MSSi_n3ZeC0t_Rnpyx8-ZvG7Afq7A1pEWP&state=5119168221224539

		# 那么把 code 复制过来
		code = 'BRWx1zB95MSSi_n3ZeC0t_Rnpyx8-ZvG7Afq7A1pEWP' #【你需要填写这里】
		resp = client.getAccessTokenByCode(code);
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

end