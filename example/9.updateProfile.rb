# 修改用户资料
# https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E4%BF%AE%E6%94%B9%E7%94%A8%E6%88%B7%E8%B5%84%E6%96%99
# 修改用户资料，此接口不能用于修改手机号、邮箱、密码，如果需要请调用 updatePhone、updateEmail、updatePassword 接口。

# 如何运行
# ruby ./example/9.updateProfile.rb

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example')

# 输出 gem 的版本
authing_ruby_gem_version = Gem.loaded_specs["authing_ruby"].version
puts "您的 authing_ruby gem 版本是 #{authing_ruby_gem_version}"

# 初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
  userPoolId: ENV["userPoolId"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 先登录
username = "user9527" # 用户名
password = "12345678" # 密码
authenticationClient.loginByUsername(username, password)

# 修改用户资料
resp = authenticationClient.updateProfile({
  nickname: 'Nick-测试修改用户资料',
})
puts resp