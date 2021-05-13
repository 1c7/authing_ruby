# 只有一个用户 id，如何获得用户信息？比如 609cfa6a8dcd517d997cef90
# 用的 API 是 管理模块 -> 管理用户 -> 通过 ID 获取用户信息

# 如何使用: ruby ./example/17.get_user_info_by_user_id.rb

require_relative '../lib/authing_ruby'
require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

# 初始化
options = {
	# host: 'https://core.authing.cn',
	host: 'https://core.authing.co', # 2021-5-13 Authing 临时使用 .co
	userPoolId: ENV["userPoolId"],
	secret: ENV["secret"],
}
puts "初始化的参数是"
puts options
managementClient = AuthingRuby::ManagementClient.new(options)

# 用户 ID 
user_id = '609cfa6a8dcd517d997cef90'

# 获取用户信息
data = managementClient.users.detail(user_id)
puts "返回结果是"
puts data
# {"data":{"user":{"id":"609cfa6a8dcd517d997cef90","arn":"arn:cn:authing:60800b8ee5b66b23128b4980:user:609cfa6a8dcd517d997cef90","userPoolId":"60800b8ee5b66b23128b4980","status":"Activated","username":null,"email":"haha625@qq.com","emailVerified":false,"phone":null,"phoneVerified":false,"identities":[],"unionid":null,"openid":null,"nickname":null,"registerSource":["basic:email"],"photo":"https://files.authing.co/authing-console/default-user-avatar.png","password":"7fb23422d4dccd05a115dd8a389b72c3","oauth":null,"token":null,"tokenExpiredAt":null,"loginsCount":0,"lastLogin":null,"lastIP":null,"signedUp":"2021-05-13T10:07:38+00:00","blocked":false,"isDeleted":false,"device":null,"browser":null,"company":null,"name":null,"givenName":null,"familyName":null,"middleName":null,"profile":null,"preferredUsername":null,"website":null,"gender":"U","birthdate":null,"zoneinfo":null,"locale":null,"address":null,"formatted":null,"streetAddress":null,"locality":null,"region":null,"postalCode":null,"city":null,"province":null,"country":null,"createdAt":"2021-05-13T10:07:38+00:00","updatedAt":"2021-05-13T10:07:38+00:00","externalId":null}}}
