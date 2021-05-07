# 退出登录
# ruby ./example/11.logout.rb

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

# 例子5里我们用这个手机号和密码注册了，所以这里直接登录
phone = "13556136684"
password = "123456789"
authenticationClient.loginByPhonePassword(phone, password)

# 获取当前用户的信息
user = authenticationClient.getCurrentUser()
puts user

# 退出登录
authenticationClient.logout()

# 再次获取用户信息，这次应该是失败的
user = authenticationClient.getCurrentUser()
puts user
# {"errors"=>[{"message"=>{"code"=>2020, "message"=>"尚未登录，无访问权限"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["user"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>{"user"=>nil}}