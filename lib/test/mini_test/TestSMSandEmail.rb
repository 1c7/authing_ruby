# 有些方法必须用"短信验证码"或"邮件验证码"
# 比如
#    通过短信验证码重置密码
#    通过邮件验证码重置密码
#    发送邮件
#    发送短信验证码
#    使用手机号验证码登录

# 我们将这些测试统一放到这个文件里，方便查找
# 因为这些方法需要手工测试，无法自动化

require "minitest/autorun" # Minitest
require "./lib/authing_ruby.rb" # 模块主文件
require "./lib/test/helper.rb" # 模块主文件
require 'dotenv' # 载入环境变量文件

Dotenv.load('.env.test') 

class TestSMSandEmail < Minitest::Test
	def setup
    options = {
      appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      appId: ENV["appId"], # "60800b9151d040af9016d60b"
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(options)
    @helper = Test::Helper.new

    @phone = '13556136684' # 测发短信的时候可能需要改一下这里
  end

  # 手动发送短信
  def manual_send_SMS(phone)
    sms_result = @authenticationClient.sendSmsCode(phone)
    return sms_result
    # {"code":200,"message":"发送成功"}
    #【Authing】验证码7326，该验证码5分钟内有效，请勿泄漏于他人。
  end

  # 通过短信验证码重置密码
  # ruby ./lib/test/mini_test/TestSMSandEmail.rb -n test_resetPasswordByPhoneCode
  def test_resetPasswordByPhoneCode
    phone = @phone
    code = '7326' # 记得先发验证码
    newPassword = '123456789'
    res = @authenticationClient.resetPasswordByPhoneCode(phone, code, newPassword)
		assert(res.dig("code") == 200, res)
    # 如果成功
    # {"message":"重置密码成功！","code":200}

    # 错误可能1
    # {"errors":[{"message":{"code":2004,"message":"用户不存在"},"locations":[{"line":2,"column":5}],"path":["resetPassword"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":{"resetPassword":null}}

    # 错误可能2
    # {"errors":[{"message":{"code":2001,"message":"验证码不正确！"},"locations":[{"line":2,"column":5}],"path":["resetPassword"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":{"resetPassword":null}}
  end

  # 测试: 绑定手机号
  # ruby ./lib/test/mini_test/TestSMSandEmail.rb -n test_bindPhone
  def test_bindPhone
    # 第一步：用户名注册用户
    username = "test_bindPhone_#{@helper.randomString()}"
    password = "123456789"
    @authenticationClient.registerByUsername(username, password)

    # 第二步：登录用户
    @authenticationClient.loginByUsername(username, password)

    # 第三步
    phoneCode = "8760" # 自己填一下这里
    if phoneCode == nil
      manual_send_SMS(@phone)
    else
      res = @authenticationClient.bindPhone(@phone, phoneCode)
      puts res
      # 错误情况
      # {"errors":[{"message":{"code":500,"message":"该手机号已被绑定"},"locations":[{"line":2,"column":3}],"path":["bindPhone"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":null}

      assert(res.dig('id') != nil)
    end
  end 

end