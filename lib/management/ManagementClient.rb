# 管理模块

module AuthingRuby
  class ManagementClient
    def initialize(options = {})
      @userPoolId = options.fetch(:userPoolId, nil)
      @secret = options.fetch(:secret, nil)

      # if (!this.options.userPoolId && !this.options.appId)
        # throw new Error('请提供 userPoolId 或者 appId!');

      # @graphqlClient = 
      # @httpClient = 
      # @tokenProvider = 
      # @publicKeyManager = 
      # @users = AuthingRuby::UsersManagementClient.new(
      #   options,
      #   this.graphqlClient,
      #   this.httpClient,
      #   this.tokenProvider,
      #   this.publicKeyManager
      # );
    end

    # 管理员创建账号
    # https://docs.authing.cn/v2/guides/user/create-user/
  end
end