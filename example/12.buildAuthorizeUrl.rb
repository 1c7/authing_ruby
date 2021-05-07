# 用户认证模块 -> 标准协议认证模块 -> 生成 OIDC 协议的用户登录链接
# AuthenticationClient.buildAuthorizeUrl(options)
# 生成 OIDC 协议的用户登录链接，用户可以通过此链接访问 Authing 的在线登录页面。
# https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html#%E7%94%9F%E6%88%90-oidc-%E5%8D%8F%E8%AE%AE%E7%9A%84%E7%94%A8%E6%88%B7%E7%99%BB%E5%BD%95%E9%93%BE%E6%8E%A5

# ruby ./example/12.buildAuthorizeUrl.rb

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example')

# 输出 gem 的版本
authing_ruby_gem_version = Gem.loaded_specs["authing_ruby"].version
puts "您的 authing_ruby gem 版本是 #{authing_ruby_gem_version}"

options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
  redirectUri: ENV["redirectUri"], # 注意这个回调地址一定要和 Authing 里设置的一样
  protocol: 'oidc',
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)
url = authenticationClient.buildAuthorizeUrl({ scope: 'openid profile offline_access' })
puts url
# https://rails-demo.authing.cn/oidc/auth?nonce=6409438938605313&state=6386605269397348&scope=openid%20profile%20offline_access&client_id=60800b9151d040af9016d60b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthing_callback&response_type=code&prompt=consent