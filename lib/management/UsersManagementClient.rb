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

    # 修改用户资料
    def update(id, updates = {})
      # 预处理密码（如果有的话）
      password = updates.fetch(:password, nil)
      if password
        publicKey = @publicKeyManager.getPublicKey()
        encryptedPassword = Utils.encrypt(password, publicKey)
        updates[:password] = encryptedPassword
      end

      # 然后再发请求
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "id": id,
        "input": updates
      }
      res = graphqlAPI.updateUser(@graphqlClient, @tokenProvider, variables)
      return res
    end

    # 通过 ID 获取用户信息
    def detail(user_id)
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      variables = {
        "id": user_id,
      }
      res = graphqlAPI.user(@graphqlClient, @tokenProvider, variables)
      return res
    end

    # 删除用户
    def delete(user_id)
      variables = {
        "id": user_id,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      res = graphqlAPI.deleteUser(@graphqlClient, @tokenProvider, variables)
      return res
      # {"data":{"deleteUser":{"message":"删除成功！","code":200}}}
    end

    # 批量删除用户
    def deleteMany(user_ids = [])
      variables = {
        "ids": user_ids,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      res = graphqlAPI.deleteUsers(@graphqlClient, @tokenProvider, variables)
      return res
      # {"data":{"deleteUsers":{"message":"删除成功！","code":200}}}
    end

    # 获取用户列表
    def list(page = 1, limit = 10)
      variables = {
        "page": page,
        "limit": limit,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      res = graphqlAPI.users(@graphqlClient, @tokenProvider, variables)
      return res
    end

    # TODO
    # 批量获取用户
    def batch
    end

    # 检查用户是否存在
    def exists(options = {})
      username = options.fetch(:username, nil)
      email = options.fetch(:email, nil)
      phone = options.fetch(:phone, nil)
      if username == nil && email == nil && phone == nil
        throw "缺少参数, 请至少传入一个选项: username, email, phone"
      end
      
      variables = {
        "username": username,
        "email": email,
        "phone": phone,
      }
      graphqlAPI = AuthingRuby::GraphQLAPI.new
      res = graphqlAPI.isUserExists(@graphqlClient, @tokenProvider, variables)
      json = JSON.parse(res)
      return json.dig('data', "isUserExists")
    end

    # TODO
    def search
    end

    # TODO
    def refreshToken
    end

  end
end