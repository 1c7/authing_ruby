# 管理模块
require_relative './ManagementTokenProvider.rb'
require_relative './UsersManagementClient.rb'
require_relative './ApplicationsManagementClient.rb'
require_relative './AclManagementClient.rb'
require_relative './UserpoolManagementClient.rb'
require_relative './RolesManagementClient.rb'

module AuthingRuby
  class ManagementClient
    
    def initialize(options = {})
      @userPoolId = options.fetch(:userPoolId, nil)
      @secret = options.fetch(:secret, nil)
      @appId = options.fetch(:appId, nil)
      @host = options.fetch(:host, 'https://core.authing.cn')
      @accessToken = options.fetch(:accessToken, nil)
      
      if @userPoolId == nil && @appId == nil
        raise '请提供 userPoolId 或 appId!'
      end

      graphqlApiEndpointV2 = "#{@host}/graphql/v2"
      @graphqlClient = AuthingRuby::Common::GraphqlClient.new(graphqlApiEndpointV2, options)
      @tokenProvider = AuthingRuby::ManagementTokenProvider.new(options, @graphqlClient)
      @httpClient = AuthingRuby::Common::HttpClient.new(options, @tokenProvider)
      @publicKeyManager = AuthingRuby::Common::PublicKeyManager.new(options)

      @users = AuthingRuby::UsersManagementClient.new(
        options,
        @graphqlClient,
        @httpClient,
        @tokenProvider,
        @publicKeyManager
      );

      @applications = AuthingRuby::ApplicationsManagementClient.new(
        options,
        @httpClient,
        @graphqlClient,
        @tokenProvider,
      );

      @acl = AuthingRuby::AclManagementClient.new(
        options,
        @httpClient,
        @graphqlClient,
        @tokenProvider,
      );

    end

    def users
      return @users
    end

    def applications
      return @applications
    end

    def acl
      return @acl
    end
    
  end
end