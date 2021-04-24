# 管理模块

module AuthingRuby
  class ManagementClient
    def initialize(options = {})
      @userPoolId = options.fetch(:userPoolId, nil)
      @secret = options.fetch(:secret, nil)
    end

    # 管理员创建账号
    # https://docs.authing.cn/v2/guides/user/create-user/
  end
end