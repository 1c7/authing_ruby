# 例子3: 发送手机验证码
# 如何运行: ruby ./example/3.sendSmsCode.rb

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example')

# 第一步：初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
  userPoolId: ENV["userPoolId"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 第二步：发送
phone = "[请填写您的手机号码]" # 比如135xxxxoooo
resp = authenticationClient.sendSmsCode(phone)

puts resp
# 运行成功会输出: {"code":200,"message":"发送成功"}