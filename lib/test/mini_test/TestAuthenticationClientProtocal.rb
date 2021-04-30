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
		# 测试方法：手工把输出的 url 粘贴到浏览器里访问，如果可以正常访问就是成功
	end

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
	end

end