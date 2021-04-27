# 管理模块

module AuthingRuby
  class ManagementClient
    
    def initialize(options = {})
      @userPoolId = options.fetch(:userPoolId, nil)
      @secret = options.fetch(:secret, nil)
      @appId = options.fetch(:appId, nil)
      @host = options.fetch(:host, nil)
      @accessToken = options.fetch(:accessToken, nil)
      
      if @userPoolId == nil && @appId == nil
        throw '请提供 userPoolId 或者 appId!'
      end

      # graphqlApiEndpointV2 = "#{@host}/graphql/v2"

      # if (@secret == nil && @accessToken == nil) {
      #   onError(1000, 'Init Management Client failed, must provide at least secret or accessToken !')
      # end

      # @graphqlClient = AuthingRuby::GraphqlClient.new(graphqlEndpoint, @options)
      # @tokenProvider = Authentication::AuthenticationTokenProvider.new()
      # this.tokenProvider = new ManagementTokenProvider(
      #   this.options,
      #   this.graphqlClient
      # );
      # this.httpClient = new (this.options.httpClient || HttpClient)(
      #   this.options,
      #   this.tokenProvider
      # );
      # this.publicKeyManager = new PublicKeyManager(this.options, this.httpClient);

      # @graphqlClient = GraphqlClient
      # @httpClient = 
      # @tokenProvider = 
      # @publicKeyManager = 

      # @users = AuthingRuby::UsersManagementClient.new(
      #   options,
      #   @graphqlClient,
      #   @httpClient,
      #   @tokenProvider,
      #   @publicKeyManager
      # );
    end

    # def onError(code, message)
    #   throw { code, message }
    # end

    # 管理员创建账号
    # https://docs.authing.cn/v2/guides/user/create-user/
  end
end