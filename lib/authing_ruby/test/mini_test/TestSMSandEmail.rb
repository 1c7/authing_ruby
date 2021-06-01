# 有些方法必须用"短信验证码"或"邮件验证码"
# 比如
#    通过短信验证码重置密码
#    通过邮件验证码重置密码
#    发送邮件
#    发送短信验证码
#    使用手机号验证码登录

# 我们将这些测试统一放到这个文件里，方便查找
# 因为这些方法需要手工测试，无法自动化
# ruby ./lib/test/mini_test/TestSMSandEmail.rb

require "minitest/autorun"
require "./lib/authing_ruby.rb"
require "./lib/authing_ruby/test/helper.rb"
require 'dotenv'
Dotenv.load('.env.test') 

class TestSMSandEmail < Minitest::Test
	def setup
    # 新建一个用户侧的
    authenticationClient_options = {
      appHost: ENV["appHost"], # "https://rails-demo.authing.cn", 
      appId: ENV["appId"], # "60800b9151d040af9016d60b"
    }
    @authenticationClient = AuthingRuby::AuthenticationClient.new(authenticationClient_options)

    # 新建一个管理侧的
    managementClient_options = {
      host: 'https://core.authing.cn',
      userPoolId: ENV["userPoolId"],
      secret: ENV["secret"],
    }
    @managementClient = AuthingRuby::ManagementClient.new(managementClient_options)

    @helper = Test::Helper.new

    @phone = '13556136684' # 测发短信时需要改一下这里, 填你自己的手机号，这样才能收到短信
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
    # 前提条件：先确保有一个用户是自己的手机号，可以直接进 Authing 手工新建一个用户。

    phone = @phone # 手机号
    phoneCode = nil # 先保持为 nil 运行一次, 触发 manual_send_SMS 发个短信，然后自己填一下 phoneCode 为手机短信收到的验证码
    if phoneCode == nil
      # manual_send_SMS(phone) # 取消这行的注释
    else
      newPassword = '123456789'
      res = @authenticationClient.resetPasswordByPhoneCode(phone, phoneCode, newPassword)
      assert(res.dig("code") == 200, res)
    end
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
    user = @authenticationClient.registerByUsername(username, password)

    # 第二步：登录用户
    @authenticationClient.loginByUsername(username, password)

    # 第三步
    phoneCode = nil # 先保持为 nil 运行一次, 触发 manual_send_SMS 发个短信，然后自己填一下 phoneCode 为手机短信收到的验证码
    if phoneCode == nil
      # manual_send_SMS(@phone) # 取消这行的注释
    else
      res = @authenticationClient.bindPhone(@phone, phoneCode)
      assert(res.dig('id') != nil)

      # 错误情况
      # puts res
      # {"errors":[{"message":{"code":500,"message":"该手机号已被绑定"},"locations":[{"line":2,"column":3}],"path":["bindPhone"],"extensions":{"code":"INTERNAL_SERVER_ERROR"}}],"data":null}
    end

    # 清理工作：测完了删除第一步注册的用户
    user_id = user['id']
    @managementClient.users.delete(user_id)
  end

  # 测试: 更新用户手机号
  # ruby ./lib/authing_ruby/test/mini_test/TestSMSandEmail.rb -n test_updatePhone
  # 文档: https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html#%E6%9B%B4%E6%96%B0%E7%94%A8%E6%88%B7%E6%89%8B%E6%9C%BA%E5%8F%B7
  def test_updatePhone
    # 前提条件：先确保有一个现有用户，可以进 Authing 手工新建一个，新建时设定手机号和密码，手机号随便填如 13511112222 密码 123456789
    
    # 先登录：
    phone = '13511112222'
    password = '123456789'
    user = @authenticationClient.loginByPhonePassword(phone, password)

    # 填写要绑定的新手机号（可以填你自己的，这样才能收到短信）
    phone = '13556136684'

    # 给新手机号发送短信验证码 (把下面这行先取消注释, 收到短信后再注释上)
    # puts manual_send_SMS(phone); return;

    # 填写收到的短信验证码
    code = '4874'

    # 默认情况下，如果用户当前已经绑定了手机号，需要同时验证原有手机号
    # 开发者也可以选择不开启 “验证原有手机号“ ，可以在 Authing 控制台 的 设置目录下的安全信息模块进行关闭。
    # 单个用户池 -> 设置 -> 安全信息 -> 用户池安全设置 -> 修改手机号时是否验证旧手机号 -> 点击开关,切换为关闭 -> 右上角"保存"
    # 由于没有2个手机号，这里是关闭后再测试
    oldPhone = nil
    oldPhoneCode = nil

    updatePhoneResult = @authenticationClient.updatePhone(phone, code, oldPhone, oldPhoneCode)
    puts updatePhoneResult
    assert(updatePhoneResult.dig('id') != nil)

    # 错误:
    # {:code=>2020, :message=>"尚未登录，无访问权限", :data=>nil}
    # {:code=>500, :message=>"该手机号已被绑定", :data=>nil}
    # {:code=>2230, :message=>"新手机号和旧手机号一样", :data=>nil}
    # {:code=>500, :message=>"修改手机号必须验证原来的手机号。", :data=>nil}
    # {:code=>500, :message=>"验证码已过期", :data=>nil}
    # {:code=>500, :message=>"验证码不正确！", :data=>nil}

    # 成功会返回 User
    # {"id"=>"60b5b17a9cf59b23b2bcbccb", "arn"=>"arn:cn:authing:60800b8ee5b66b23128b4980:user:60b5b17a9cf59b23b2bcbccb", "userPoolId"=>"60800b8ee5b66b23128b4980", "status"=>"Activated", "username"=>"测试更新手机号", "email"=>nil, "emailVerified"=>false, "phone"=>"13556136684", "phoneVerified"=>true, "unionid"=>nil, "openid"=>nil, "nickname"=>nil, "registerSource"=>["import:manual"], "photo"=>"https://files.authing.co/authing-console/default-user-avatar.png", "password"=>"871fde109c2f0f463cc35e0c3e840932", "oauth"=>nil, "token"=>"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MGI1YjE3YTljZjU5YjIzYjJiY2JjY2IiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNi0wMVQwNDoxNjo1MS41NDBaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsImFkZHJlc3MiOnsiY291bnRyeSI6bnVsbCwicG9zdGFsX2NvZGUiOm51bGwsInJlZ2lvbiI6bnVsbCwiZm9ybWF0dGVkIjpudWxsfSwicGhvbmVfbnVtYmVyIjoiMTM1MTExMTIyMjIiLCJwaG9uZV9udW1iZXJfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6bnVsbCwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJleHRlcm5hbF9pZCI6bnVsbCwidW5pb25pZCI6bnVsbCwiZGF0YSI6eyJ0eXBlIjoidXNlciIsInVzZXJQb29sSWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhcHBJZCI6IjYwYjViMjFiZTMxMjkwNjI2ZmY2ZDgyZiIsImlkIjoiNjBiNWIxN2E5Y2Y1OWIyM2IyYmNiY2NiIiwidXNlcklkIjoiNjBiNWIxN2E5Y2Y1OWIyM2IyYmNiY2NiIiwiX2lkIjoiNjBiNWIxN2E5Y2Y1OWIyM2IyYmNiY2NiIiwicGhvbmUiOiIxMzUxMTExMjIyMiIsImVtYWlsIjpudWxsLCJ1c2VybmFtZSI6Iua1i-ivleabtOaWsOaJi-acuuWPtyIsInVuaW9uaWQiOm51bGwsIm9wZW5pZCI6bnVsbCwiY2xpZW50SWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAifSwidXNlcnBvb2xfaWQiOiI2MDgwMGI4ZWU1YjY2YjIzMTI4YjQ5ODAiLCJhdWQiOiI2MGI1YjIxYmUzMTI5MDYyNmZmNmQ4MmYiLCJleHAiOjE2MjM3MzA2MzEsImlhdCI6MTYyMjUyMTAzMSwiaXNzIjoiaHR0cHM6Ly9tb3Jlbi5hdXRoaW5nLmNuL29pZGMifQ.VKSB6q-DBmtKLzOh_2qjBPQCSNZUAtrw_G2ZlNjOxbs", "tokenExpiredAt"=>"2021-06-15T04:17:11+00:00", "loginsCount"=>6, "lastLogin"=>"2021-06-01T04:17:11+00:00", "lastIP"=>nil, "signedUp"=>"2021-06-01T04:03:06+00:00", "blocked"=>false, "isDeleted"=>false, "device"=>nil, "browser"=>nil, "company"=>nil, "name"=>nil, "givenName"=>nil, "familyName"=>nil, "middleName"=>nil, "profile"=>nil, "preferredUsername"=>nil, "website"=>nil, "gender"=>"U", "birthdate"=>nil, "zoneinfo"=>nil, "locale"=>nil, "address"=>nil, "formatted"=>nil, "streetAddress"=>nil, "locality"=>nil, "region"=>nil, "postalCode"=>nil, "city"=>nil, "province"=>nil, "country"=>nil, "createdAt"=>"2021-06-01T04:03:06+00:00", "updatedAt"=>"2021-06-01T04:17:12+00:00"}
  end

end
