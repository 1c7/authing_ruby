class AuthingRuby
  def self.hi
    puts "Hello world!"
  end
end

class AuthingRuby::AuthenticationClient
  def initialize(params = {})
    @appId = params.fetch(:appId, nil) # 应用 ID
    # https://docs.authing.cn/v2/guides/faqs/get-app-id-and-secret.html
    # 如何获取应用 ID (AppID) 和应用密钥（AppSecret）
    # appHost 是 该应用的域名（AppHost），如 https://my-awesome-app.authing.cn
    # appHost 的获取方法：某用户池 -> 应用 -> 基础设置 -> 认证地址
    if @appId == nil
      # 提示 appId 是个必须的参数
    end

    @secret = params.fetch(:secret, nil) # 应用密钥
    @appHost = params.fetch(:appHost, nil) # 该应用的域名
    @redirectUri = params.fetch(:redirectUri, nil) # 业务回调地址
    # protocol: 'oidc',
  end

  def getAccessTokenByCode(code)
  end

  # 使用邮箱注册
  # https://docs.authing.cn/v2/reference/sdk-for-node/authentication/AuthenticationClient.html
  def registerByEmail(email, password, profile, options)
    # TODO
  end
  # 使用邮箱密码注册
  # authenticationClient.registerByEmail('test@example.com', 'passw0rd')

  # 使用邮箱登录
  def loginByEmail()
    # TODO
  end

  # 使用用户名注册
  def registerByUsername(username, password, profile, options)
    # TODO
  end

end

# 管理模块
class class AuthingRuby::ManagementClient
  # TODO
end