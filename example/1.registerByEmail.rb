#
# 例子1: 通过邮箱地址+密码注册
#

# 如何运行: ruby ./example/1.registerByEmail.rb

# 载入方法1：载入安装的 gem
# require 'authing_ruby'

# 载入方法2：直接载入本地 gem，适合开发环境
require_relative '../lib/authing_ruby'

require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

# puts Gem.loaded_specs
# return

# 输出 gem 的版本
authing_ruby_gem_spec = Gem.loaded_specs.fetch("authing_ruby", nil)
puts "您的 authing_ruby gem 版本是 #{authing_ruby_gem_spec.version}" if authing_ruby_gem_spec

# 第一步：初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 第二步：注册
email = "haha#{rand(0..1000)}@qq.com" # 邮件地址
password = "12345678" # 密码
resp = authenticationClient.registerByEmail(email, password)

# 第三步：查看结果
puts "返回的结果是"
puts resp


# 如果返回的结果类似这样, 就是成功了: 
=begin
{
  "id": "6083f9c88b1abc66c4748a1f",
  "arn": "arn:cn:authing:60800b8ee5b66b23128b4980:user:6083f9c88b1abc66c4748a1f",
  "userPoolId": "60800b8ee5b66b23128b4980",
  "status": "Activated",
  "username": null,
  "email": "haha2@qq.com",
  "emailVerified": false,
  "phone": null,
  "phoneVerified": false,
  "unionid": null,
  "openid": null,
  "nickname": null,
  "registerSource": ["basic:email"],
  "photo": "default-user-avatar.png",
  "password": "5dbd9662bfd3915e237150a4fb145546",
  "oauth": null,
  "token": null,
  "tokenExpiredAt": null,
  "loginsCount": 0,
  "lastLogin": null,
  "lastIP": null,
  "signedUp": null,
  "blocked": false,
  "isDeleted": false,
  "device": null,
  "browser": null,
  "company": null,
  "name": null,
  "givenName": null,
  "familyName": null,
  "middleName": null,
  "profile": null,
  "preferredUsername": null,
  "website": null,
  "gender": "U",
  "birthdate": null,
  "zoneinfo": null,
  "locale": null,
  "address": null,
  "formatted": null,
  "streetAddress": null,
  "locality": null,
  "region": null,
  "postalCode": null,
  "city": null,
  "province": null,
  "country": null,
  "createdAt": "2021-04-24T10:58:16+00:00",
  "updatedAt": "2021-04-24T10:58:16+00:00",
  "externalId": null
}
=end

# 如果邮件地址重复会报错：
=begin
{
  "errors": [{
    "message": {
      "code": 2026,
      "message": "用户已存在，请直接登录！"
    },
    "locations": [{
      "line": 2,
      "column": 3
    }],
    "path": ["registerByEmail"],
    "extensions": {
      "code": "INTERNAL_SERVER_ERROR"
    }
  }],
  "data": {
    "registerByEmail": null
  }
}
=end