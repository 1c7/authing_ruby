#
# 例子2: 通过用户名+密码注册
#

# 如何运行: ruby ./example/2.registerByUsername.rb
# 其实这个和 "例子1: 邮箱+密码注册" 非常相似，只是换了个方法。  

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

# 输出 gem 的版本
authing_ruby_gem_version = Gem.loaded_specs["authing_ruby"].version
puts "您的 authing_ruby gem 版本是 #{authing_ruby_gem_version}"

# 第一步：初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 第二步：注册
username = "user#{rand(0...9999)}" # 用户名
password = "12345678" # 密码
resp = authenticationClient.registerByUsername(username, password)

# 第三步：查看结果
puts "返回的结果是"
puts resp


# 运行成功会看到
=begin
{
  "id": "6083fd304bed72c74b8e3c49",
  "arn": "arn:cn:authing:60800b8ee5b66b23128b4980:user:6083fd304bed72c74b8e3c49",
  "userPoolId": "60800b8ee5b66b23128b4980",
  "status": "Activated",
  "username": "user1234",
  "email": null,
  "emailVerified": false,
  "phone": null,
  "phoneVerified": false,
  "unionid": null,
  "openid": null,
  "nickname": null,
  "registerSource": ["basic:username-password"],
  "photo": "default-user-avatar.png",
  "password": "4157c178bddac42e433d1742a3542e4d",
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
  "createdAt": "2021-04-24T11:12:48+00:00",
  "updatedAt": "2021-04-24T11:12:48+00:00",
  "externalId": null
}
=end


# 如果用户名重复了
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
    "path": ["registerByUsername"],
    "extensions": {
      "code": "INTERNAL_SERVER_ERROR"
    }
  }],
  "data": {
    "registerByUsername": null
  }
}
=end