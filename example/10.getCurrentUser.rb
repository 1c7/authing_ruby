# 获取当前登录的用户信息
# ruby ./example/10.getCurrentUser.rb

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

# 然后获取当前用户的信息
user = authenticationClient.getCurrentUser()
puts user
# {"id"=>"6094e641520d730a13499778", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e641520d730a13499778", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>nil, "email"=>nil, "emailVerified"=>false, "phone"=>"13556136684", "phoneVerified"=>true, "identities"=>[], "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:phone-code"], "photo"=>"https://files.authing.co/authing-console/default-user-avatar.png", "password"=>"ae000f19b610ad340b9052f2dab252e1", "oauth"=>nil, "token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDk0ZTY0MTUyMGQ3MzBhMTM0OTk3NzgiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0wN1QwNzoxNzoyNi42MjZaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjoiMTM1NTYxMzY2ODQiLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOnRydWUsImVtYWlsIjpudWxsLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImV4dGVybmFsX2lkIjpudWxsLCJ1bmlvbmlkIjpudWxsLCJkYXRhIjp7InR5cGUiOiJ1c2VyIiwidXNlclBvb2xJZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCIsImFwcElkIjoiNjA4MDBiOTE1MWQwNDBhZjkwMTZkNjBiIiwiaWQiOiI2MDk0ZTY0MTUyMGQ3MzBhMTM0OTk3NzgiLCJ1c2VySWQiOiI2MDk0ZTY0MTUyMGQ3MzBhMTM0OTk3NzgiLCJfaWQiOiI2MDk0ZTY0MTUyMGQ3MzBhMTM0OTk3NzgiLCJwaG9uZSI6IjEzNTU2MTM2Njg0IiwiZW1haWwiOm51bGwsInVzZXJuYW1lIjpudWxsLCJ1bmlvbmlkIjpudWxsLCJvcGVuaWQiOm51bGwsImNsaWVudElkIjoiNjA4MDBiOGVlNWI2NmIyMzEyOGI0OTgwIn0sInVzZXJwb29sX2lkIjoiNjA4MDBiOGVlNWI2NmIyMzEyOGI0OTgwIiwiYXVkIjoiNjA4MDBiOTE1MWQwNDBhZjkwMTZkNjBiIiwiZXhwIjoxNjIxNTgyNTUzLCJpYXQiOjE2MjAzNzI5NTMsImlzcyI6Imh0dHBzOi8vcmFpbHMtZGVtby5hdXRoaW5nLmNuL29pZGMifQ.JZ5HDPJ83X5fRr80lS7WOhAdAC7Exd0HJE3ods0pfhM", "tokenExpiredAt"=>"2021-05-21T07:35:53+00:00", "loginsCount"=>2, "lastLogin"=>"2021-05-07T07:35:53+00:00", "lastIP"=>nil, "signedUp"=>"2021-05-07T07:03:29+00:00", "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:03:29+00:00", "updatedAt"=>"2021-05-07T07:35:53+00:00", "externalId"=>nil}