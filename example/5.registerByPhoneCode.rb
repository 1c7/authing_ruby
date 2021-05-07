# 使用手机号注册
# ruby ./example/5.registerByPhoneCode.rb

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

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

# 手机号
phone = "13556136684" # 比如135xxxxoooo

# 第二步：发手机验证码 （这一段取消注释，注意最后有个 return，阻止运行第三步）
# sms_resp = authenticationClient.sendSmsCode(phone)
# puts sms_resp; return;

# 第三步：手机号+验证码+密码 进行注册 （第二步跑完再跑这一步）
code = '8177'
password = "123456789"
resp = authenticationClient.registerByPhoneCode(phone, code, password)
puts resp

# 成功返回
resp_example = {
	"id"=>"6094e641520d730a13499778", 
	"arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e641520d730a13499778", 
	"userPoolId"=>"60800b8ee5b66b23128b4980", 
	"status"=>"Activated", 
	"username"=>nil, 
	"email"=>nil, 
	"emailVerified"=>false, 
	"phone"=>"13556136684", 
	"phoneVerified"=>true, 
	"unionid"=>nil, 
	"openid"=>nil, 
	"nickname"=>nil, 
	"registerSource"=>["basic:phone-code"], 
	"photo"=>"default-user-avatar.png", 
	"password"=>"ae000f19b610ad340b9052f2dab252e1", 
	"oauth"=>nil, 
	"token"=>nil, 
	"tokenExpiredAt"=>nil, 
	"loginsCount"=>0, 
	"lastLogin"=>nil, 
	"lastIP"=>nil, 
	"signedUp"=>nil, 
	"blocked"=>false, 
	"isDeleted"=>false, 
	"device"=>nil, 
	"browser"=>nil, 
	"company"=>nil, 
	"name"=>nil, 
	"givenName"=>nil, 
	"familyName"=>nil, 
	"middleName"=>nil, 
	"profile"=>nil, 
	"preferredUsername"=>nil, 
	"website"=>nil, 
	"gender"=>"U", 
	"birthdate"=>nil, 
	"zoneinfo"=>nil, 
	"locale"=>nil, 
	"address"=>nil, 
	"formatted"=>nil, 
	"streetAddress"=>nil, 
	"locality"=>nil, 
	"region"=>nil, 
	"postalCode"=>nil, 
	"city"=>nil, 
	"province"=>nil, 
	"country"=>nil, 
	"createdAt"=>"2021-05-07T07:03:29+00:00", 
	"updatedAt"=>"2021-05-07T07:03:29+00:00", 
	"externalId"=>nil
}

# 失败返回
error_example = {"errors"=>[{"message"=>{"code"=>2001, "message"=>"验证码不正确！"}, "locations"=>[{"line"=>2, "column"=>3}], "path"=>["registerByPhoneCode"], "extensions"=>{"code"=>"INTERNAL_SERVER_ERROR"}}], "data"=>{"registerByPhoneCode"=>nil}}