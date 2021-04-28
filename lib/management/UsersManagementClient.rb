# UsersManagementClient 负责什么？
# https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts

module AuthingRuby	
  class UsersManagementClient

    def initialize(options = {}, graphqlClient = nil, httpClient = nil, tokenProvider = nil, publicKeyManager = nil)
      @options = options
      @graphqlClient = graphqlClient
      @httpClient = httpClient
      @tokenProvider = tokenProvider
      @publicKeyManager = publicKeyManager
    end

    # 创建用户
    # 代码参考: https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts#L99
    def create(userInfo = {}, options = {})
      keepPassword = options.fetch(:keepPassword, false)
      password = userInfo.fetch(:password, nil)
      # 先对密码进行处理
      if password
        publicKey = @publicKeyManager.getPublicKey()
        encryptedPassword = Utils.encrypt(password, publicKey)
        userInfo[:password] = encryptedPassword
      end

      # 然后再发请求
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "userInfo": userInfo,
        "keepPassword": keepPassword,
      }
      res = graphqlAPI.createUser(@graphqlClient, @tokenProvider, variables)
      return res
    end

    # 这是干嘛？
    # 发了一个 GraphQL 请求
    # TODO
    # export const createUser = async (
    # 	garpqhlClient: GraphqlClient,
    # 	tokenProvider: ManagementTokenProvider | AuthenticationTokenProvider,
    # 	variables: CreateUserVariables
    # ): Promise<CreateUserResponse> => {
    # 	const query = CreateUserDocument;
    # 	const token = await tokenProvider.getToken();
    # 	return garpqhlClient.request({
    # 		query,
    # 		token,
    # 		variables
    # 	});
    # };

    # TODO
    # 修改用户资料
    # 代码参考 https://github.com/Authing/authing.js/blob/master/src/lib/management/UsersManagementClient.ts#L189
    def update
    end

    # TODO
    def detail
    end

    # TODO
    def delete(userId)
    end

    # TODO
    def deleteMany(userIds = [])
    end

    # TODO
    # 批量获取用户
    def batch
    end
    
    # TODO
    # 获取用户列表
    def list
    end

    # 检查用户是否存在
    def exists
    end

    # TODO
    def search
    end

    # TODO
    def refreshToken
    end

  end
end