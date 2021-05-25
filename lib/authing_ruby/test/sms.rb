# 发短信
# ruby ./lib/authing_ruby/test/sms.rb

require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/authing_ruby/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') # 你可以编辑这个文件来修改环境变量

options = {
	# appHost: ENV["appHost"] || , # "https://rails-demo.authing.cn", 
	# appId: ENV["appId"], # "60800b9151d040af9016d60b"
  appId: "60ab26fe5be730bfc1742c68",
  appHost: "https://hn-staging.authing.cn",
}
@authenticationClient = AuthingRuby::AuthenticationClient.new(options)
phone = "13556136684"
sms_result = @authenticationClient.sendSmsCode(phone)
puts sms_result