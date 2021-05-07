# 使用邮箱登录 
# ruby ./example/6.loginByEmail.rb

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

# 定好邮箱和密码
email = '301@qq.com'
password = "123456789"

# 先注册
register_resp = authenticationClient.registerByEmail(email, password)
puts register_resp
# {"id"=>"6094e81c938a34311f754b85", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e81c938a34311f754b85", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>nil, "email"=>"301@qq.com", "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:email"], "photo"=>"default-user-avatar.png", "password"=>"fd6653a855bf62cdffe0a0fa97df33fd", "oauth"=>nil, "token"=>nil, "tokenExpiredAt"=>nil, "loginsCount"=>0, "lastLogin"=>nil, "lastIP"=>nil, "signedUp"=>nil, "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:11:24+00:00", "updatedAt"=>"2021-05-07T07:11:24+00:00", "externalId"=>nil}

# 再登录
login_resp = authenticationClient.loginByEmail(email, password)
puts login_resp
# {"id"=>"6094e81c938a34311f754b85", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e81c938a34311f754b85", "status"=>"Activated", "userPoolId"=>"60800b8ee5b66b23128b4980", "username"=>nil, "email"=>"301@qq.com", "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:email"], "photo"=>"https://files.authing.co/authing-console/default-user-avatar.png", "password"=>"fd6653a855bf62cdffe0a0fa97df33fd", "oauth"=>nil, "token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDk0ZTgxYzkzOGEzNDMxMWY3NTRiODUiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0wN1QwNzoxMToyNC4yNzJaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjpudWxsLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6IjMwMUBxcS5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImV4dGVybmFsX2lkIjpudWxsLCJ1bmlvbmlkIjpudWxsLCJkYXRhIjp7InR5cGUiOiJ1c2VyIiwidXNlclBvb2xJZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCIsImFwcElkIjoiNjA4MDBiOTE1MWQwNDBhZjkwMTZkNjBiIiwiaWQiOiI2MDk0ZTgxYzkzOGEzNDMxMWY3NTRiODUiLCJ1c2VySWQiOiI2MDk0ZTgxYzkzOGEzNDMxMWY3NTRiODUiLCJfaWQiOiI2MDk0ZTgxYzkzOGEzNDMxMWY3NTRiODUiLCJwaG9uZSI6bnVsbCwiZW1haWwiOiIzMDFAcXEuY29tIiwidXNlcm5hbWUiOm51bGwsInVuaW9uaWQiOm51bGwsIm9wZW5pZCI6bnVsbCwiY2xpZW50SWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAifSwidXNlcnBvb2xfaWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIiLCJleHAiOjE2MjE1ODEwODUsImlhdCI6MTYyMDM3MTQ4NSwiaXNzIjoiaHR0cHM6Ly9yYWlscy1kZW1vLmF1dGhpbmcuY24vb2lkYyJ9.k-Rm69ruH5ihO6JagLUA1fpSkhi0XIQhwwG8fyfyn74", "tokenExpiredAt"=>"2021-05-21T07:11:25+00:00", "loginsCount"=>1, "lastLogin"=>"2021-05-07T07:11:25+00:00", "lastIP"=>"223.104.66.68", "signedUp"=>"2021-05-07T07:11:24+00:00", "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:11:24+00:00", "updatedAt"=>"2021-05-07T07:11:25+00:00", "externalId"=>nil}
