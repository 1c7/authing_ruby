# 使用用户名登录
# ruby ./example/7.loginByUsername.rb

# require 'authing_ruby'

# 载入方法2：直接载入本地 gem，适合开发环境
require_relative '../lib/authing_ruby'

require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

# 初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 定好用户名和密码
username = "user9527" # 用户名
password = "12345678" # 密码

# 先注册
register_resp = authenticationClient.registerByUsername(username, password)
puts register_resp
# {"id"=>"6094e8f02996bde98a56ed01", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e8f02996bde98a56ed01", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>"user9527", "email"=>nil, "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:username-password"], "photo"=>"default-user-avatar.png", "password"=>"8ec053e999798c3f82cb55bb8c5fc760", "oauth"=>nil, "token"=>nil, "tokenExpiredAt"=>nil, "loginsCount"=>0, "lastLogin"=>nil, "lastIP"=>nil, "signedUp"=>nil, "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:14:56+00:00", "updatedAt"=>"2021-05-07T07:14:56+00:00", "externalId"=>nil}

# 再登录
login_resp = authenticationClient.loginByUsername(username, password)
puts login_resp
# {"id"=>"6094e8f02996bde98a56ed01", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:6094e8f02996bde98a56ed01", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>"user9527", "email"=>nil, "emailVerified"=>false, "phone"=>nil, "phoneVerified"=>false, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["basic:username-password"], "photo"=>"https://files.authing.co/authing-console/default-user-avatar.png", "password"=>"8ec053e999798c3f82cb55bb8c5fc760", "oauth"=>nil, "token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDk0ZThmMDI5OTZiZGU5OGE1NmVkMDEiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0wN1QwNzoxNDo1Ni43MjBaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjpudWxsLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6bnVsbCwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJleHRlcm5hbF9pZCI6bnVsbCwidW5pb25pZCI6bnVsbCwiZGF0YSI6eyJ0eXBlIjoidXNlciIsInVzZXJQb29sSWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhcHBJZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImlkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwidXNlcklkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwiX2lkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwicGhvbmUiOm51bGwsImVtYWlsIjpudWxsLCJ1c2VybmFtZSI6InVzZXI5NTI3IiwidW5pb25pZCI6bnVsbCwib3BlbmlkIjpudWxsLCJjbGllbnRJZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCJ9LCJ1c2VycG9vbF9pZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCIsImF1ZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImV4cCI6MTYyMTU4MTI5OCwiaWF0IjoxNjIwMzcxNjk4LCJpc3MiOiJodHRwczovL3JhaWxzLWRlbW8uYXV0aGluZy5jbi9vaWRjIn0.YFIsdbSHKzpYdjgnBTnmGK8Cf1wzxrHsikKG-2pcLSo", "tokenExpiredAt"=>"2021-05-21T07:14:58+00:00", "loginsCount"=>1, "lastLogin"=>"2021-05-07T07:14:58+00:00", "lastIP"=>"223.104.66.68", "signedUp"=>"2021-05-07T07:14:56+00:00", "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-05-07T07:14:56+00:00", "updatedAt"=>"2021-05-07T07:14:58+00:00", "externalId"=>nil}