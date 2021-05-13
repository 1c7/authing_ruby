# 演示本地验证 id token

# 来自于: 
# 使用指南 -> 常见问题 -> 如何验证用户身份凭证（token）
# https://docs.authing.cn/v2/guides/faqs/how-to-validate-user-token.html

# 如何运行 ruby ./example/14.verify_id_token_locally_method_1.rb

require_relative '../lib/authing_ruby'
require 'dotenv'
require 'jwt'
require 'date'
Dotenv.load('.env.example') # 载入环境变量文件

# 初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 1. 先登录
username = "user9527" # 用户名
password = "12345678" # 密码
# resp = authenticationClient.loginByUsername(username, password)

# 拿到 id token
# id_token = resp['token']
# puts id_token

# 为了方便测试，不用每次都登录，把 id token 写死在这里
id_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDk0ZThmMDI5OTZiZGU5OGE1NmVkMDEiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOiJOaWNrLea1i-ivleS_ruaUueeUqOaIt-i1hOaWmSIsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0xM1QxMDoxNjowNy40MTVaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjpudWxsLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6bnVsbCwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJleHRlcm5hbF9pZCI6bnVsbCwidW5pb25pZCI6bnVsbCwiZGF0YSI6eyJ0eXBlIjoidXNlciIsInVzZXJQb29sSWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhcHBJZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImlkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwidXNlcklkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwiX2lkIjoiNjA5NGU4ZjAyOTk2YmRlOThhNTZlZDAxIiwicGhvbmUiOm51bGwsImVtYWlsIjpudWxsLCJ1c2VybmFtZSI6InVzZXI5NTI3IiwidW5pb25pZCI6bnVsbCwib3BlbmlkIjpudWxsLCJjbGllbnRJZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCJ9LCJ1c2VycG9vbF9pZCI6IjYwODAwYjhlZTViNjZiMjMxMjhiNDk4MCIsImF1ZCI6IjYwODAwYjkxNTFkMDQwYWY5MDE2ZDYwYiIsImV4cCI6MTYyMjExMTYxNCwiaWF0IjoxNjIwOTAyMDE0LCJpc3MiOiJodHRwczovL3JhaWxzLWRlbW8uYXV0aGluZy5jbi9vaWRjIn0.SOXEaaQjcUoC6VEiWLWhO-X4lfhYyoKr0dDWe99qBZo"

# HS256 方法
# 可以在 "应用 -> 授权 -> id_token 签名算法" 这里看到，选的是不是 HS256
appSecret = ENV["appSecret"]
hmac_secret = appSecret

# 按 jwt gem 官方文档的说明进行使用 https://github.com/jwt/ruby-jwt
decoded_token = JWT.decode id_token, hmac_secret, true, { algorithm: 'HS256' }
payload = decoded_token[0]
header = decoded_token[1]

# puts payload
# {"sub"=>"6094e8f02996bde98a56ed01", "birthdate"=>nil, "family_name"=>nil, "gender"=>"U", "given_name"=>nil, "locale"=>nil, "middle_name"=>nil, "name"=>nil, "nickname"=>"Nick-测试修改用户资料", "picture"=>"https://files.authing.co/authing-console/default-user-avatar.png", "preferred_username"=>nil, "profile"=>nil, "updated_at"=>"2021-05-13T10:16:07.415Z", "website"=>nil, "zoneinfo"=>nil, "address"=>{"country"=>nil, "postal_code"=>nil, "region"=>nil, "formatted"=>nil}, "phone_number"=>nil, "phone_number_verified"=>false, "email"=>nil, "email_verified"=>false, "external_id"=>nil, "unionid"=>nil, "data"=>{"type"=>"user", "userPoolId"=>"60800b8ee5b66b23128b4980", "appId"=>"60800b9151d040af9016d60b", "id"=>"6094e8f02996bde98a56ed01", "userId"=>"6094e8f02996bde98a56ed01", "_id"=>"6094e8f02996bde98a56ed01", "phone"=>nil, "email"=>nil, "username"=>"user9527", "unionid"=>nil, "openid"=>nil, "clientId"=>"60800b8ee5b66b23128b4980"}, "userpool_id"=>"60800b8ee5b66b23128b4980", "aud"=>"60800b9151d040af9016d60b", "exp"=>1622111614, "iat"=>1620902014, "iss"=>"https://rails-demo.authing.cn/oidc"}

# 过期时间的时间戳
exp = payload["exp"]
# puts exp # 1622111614

# 把时间戳变成人类可读格式
exp_readable = DateTime.strptime(exp.to_s,'%s')
puts "id_token 的过期时间是 #{exp_readable}"

# 对比过期时间和现在，判断过期没有
current_timestamp = Time.now.to_i
current_time = DateTime.strptime(current_timestamp.to_s,'%s')
puts "现在的时间是 #{current_time}"

if current_timestamp > exp
	puts "id_token 过期了"
else
	puts "id_token 没过期"
end