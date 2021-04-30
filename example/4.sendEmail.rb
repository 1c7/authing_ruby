#
# 例子4: 发送邮件
#

# 如何运行: ruby ./example/4.sendEmail.rb

require 'authing_ruby'
require 'dotenv'
Dotenv.load('.env.example') # 载入环境变量文件

# 第一步：初始化
options = {
  appId: ENV["appId"],
  appHost: ENV["appHost"], 
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)

# 第二步: 发邮件
email = '[请填写您的邮件地址]' # 比如 guokrfans@gmail.com
scene = "VERIFY_EMAIL" 

# scene 可选值有：
# RESET_PASSWORD  发送重置密码邮件，邮件中包含验证码
# VERIFY_EMAIL  发送验证邮箱的邮件
# CHANGE_EMAIL  发送修改邮箱邮件，邮件中包含验证码
# MFA_VERIFY  发送 MFA 验证邮件

# 您可以通过 JS SDK 来查证 scene 的源代码
# https://github.com/Authing/authing.js/blob/196b33fe0c7f510ca26cda4d172939e1c74cc5f7/src/types/graphql.v2.ts#L1701

resp = authenticationClient.sendEmail(email, scene)
puts resp
# 运行成功会输出 {"data":{"sendEmail":{"message":"","code":200}}}
