# 本例子演示如何查询用户登录状态。

# 概念：
# https://docs.authing.cn/v2/concepts/single-sign-on-and-single-sign-out.html
# 用户完成认证后，他在 Authing 就是已登录的状态，业务系统可以向 Authing 询问某个用户是否为登录态，从而完成多个应用系统间的单点登录。不是任何人都可以随意询问用户的登录状态，这样会有安全隐患，只有用户自己可以询问自己的登录状态，用户池管理员可以询问用户池下任意用户的登录状态。

# 使用的 API 是：
# 用户认证模块 -> 认证核心模块 -> 检测 Token 登录状态
# AuthenticationClient().checkLoginStatus(id_token)
# 注意，这是需要发一次网络请求的，所以速度较慢，不适合频繁调用

# 如何测试: 
# 1. 先登录，获取到 id token
# 2. 查询 id token 的登录状态，此时应该显示 "已登录"
# 3. 退出登录
# 4. 再次查询 id token 的登录状态，此时应该显示不同的状态


# 如何运行: ruby ./example/13.checkLoginStatus.rb

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

# 1. 先登录
username = "user9527" # 用户名
password = "12345678" # 密码
resp = authenticationClient.loginByUsername(username, password)

# 拿到 id token
id_token = resp['token']

# 2. 验证 token 
data1 = authenticationClient.checkLoginStatus(id_token)
puts data1
# {"code"=>200, "message"=>"已登录", "status"=>true, "exp"=>1622110515, "iat"=>1620900915, "data"=>{"id"=>"6094e8f02996bde98a56ed01", "userPoolId"=>"60800b8ee5b66b23128b4980", "arn"=>nil}}

# 3. 退出登录
authenticationClient.logout()

# 4. 再次验证这个 id token
data2 = authenticationClient.checkLoginStatus(id_token)
puts data2
# {"code"=>2206, "message"=>"登录信息已过期", "status"=>false, "exp"=>nil, "iat"=>nil, "data"=>nil}