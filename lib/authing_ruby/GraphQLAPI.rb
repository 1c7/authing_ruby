# 类似 JS SDK 里 src/lib/graphqlapi.ts 的用途，把请求进行封装

# 使用示例
# graphqlAPI = AuthingRuby::GraphQLAPI.new
# graphqlAPI.getAccessToken(graphqlClient, variables)

# 一共有三个参数
# (garpqhlClient, tokenProvider = nil, variables = nil)
  # garpqhlClient 是 lib/authing_ruby/common/GraphqlClient.rb
  # tokenProvider 是 lib/authing_ruby/authentication/AuthenticationTokenProvider.rb
  # variables 就是参数

module AuthingRuby
  class GraphQLAPI

    def initialize()
      @folder_graphql = File.join(File.dirname(File.expand_path(__FILE__)), "/graphql")
      @folder_mutation = "#{@folder_graphql}/mutations"
      @folder_query = "#{@folder_graphql}/queries"
    end

    def getCurrentUser(garpqhlClient, tokenProvider, variables)
      return _graphql_query_request("user", garpqhlClient, tokenProvider, variables)
    end

    def sendEmail(garpqhlClient, variables)
      return _graphql_mutation_request("sendEmail", garpqhlClient, nil, variables)
    end

    def loginByPhonePassword(garpqhlClient, variables)
      return _graphql_mutation_request("loginByPhonePassword", garpqhlClient, nil, variables)
    end

    def loginByPhoneCode(garpqhlClient, variables)
      return _graphql_mutation_request("loginByPhoneCode", garpqhlClient, nil, variables)
    end
    
    def loginByUsername(garpqhlClient, variables)
      return _graphql_mutation_request("loginByUsername", garpqhlClient, nil, variables)
    end

    def loginByEmail(garpqhlClient, variables)
      return _graphql_mutation_request("loginByEmail", garpqhlClient, nil, variables)
    end

    def registerByPhoneCode(garpqhlClient, variables)
      return _graphql_mutation_request("registerByPhoneCode", garpqhlClient, nil, variables)
    end

    def registerByUsername(garpqhlClient, variables)
      return _graphql_mutation_request("registerByUsername", garpqhlClient, nil, variables)
    end

    def registerByEmail(garpqhlClient, variables)
      return _graphql_mutation_request("registerByEmail", garpqhlClient, nil, variables)
    end

    def getAccessToken(garpqhlClient, variables)
      return _graphql_query_request("accessToken", garpqhlClient, nil, variables)
    end

    def refreshAccessToken(garpqhlClient, variables)
      return _graphql_mutation_request("refreshAccessToken", garpqhlClient, nil, variables)
    end

    def createUser(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("createUser", garpqhlClient, tokenProvider, variables)
    end

    def updateUser(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("updateUser", garpqhlClient, tokenProvider, variables)
    end

    def user(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_query_request("user", garpqhlClient, tokenProvider, variables)
    end

    def deleteUser(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("deleteUser", garpqhlClient, tokenProvider, variables)
    end

    def deleteUsers(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("deleteUsers", garpqhlClient, tokenProvider, variables)
    end

    def users(garpqhlClient, tokenProvider = nil, variables = nil);
      return _graphql_query_request("users", garpqhlClient, tokenProvider, variables)
    end

    # 检查用户是否存在
    def isUserExists(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_query_request("isUserExists", garpqhlClient, tokenProvider, variables)
    end

    # 查找用户
    def findUser(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_query_request("findUser", garpqhlClient, tokenProvider, variables)
    end

    # 检查密码强度
    def checkPasswordStrength(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_query_request("checkPasswordStrength", garpqhlClient, tokenProvider, variables)
    end

    # 检测 Token 登录状态
    def checkLoginStatus(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_query_request("checkLoginStatus", garpqhlClient, tokenProvider, variables)
    end

    # 更新用户密码
    def updatePassword(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("updatePassword", garpqhlClient, tokenProvider, variables)
    end

    # 重置密码
    def resetPassword(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("resetPassword", garpqhlClient, tokenProvider, variables)
    end

    # 更新用户手机号码
    def updatePhone(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("updatePhone", garpqhlClient, tokenProvider, variables)
    end

    def bindPhone(garpqhlClient, tokenProvider = nil, variables = nil)
      return _graphql_mutation_request("bindPhone", garpqhlClient, tokenProvider, variables)
    end

    # 太多同样写法的 method 了，稍微抽象一下
    # 这个负责发 mutation 的 request
    # 第一个参数 gql_file_name 就是文件名
    def _graphql_mutation_request(gql_file_name, garpqhlClient, tokenProvider, variables)
      file = File.open("#{@folder_mutation}/#{gql_file_name}.gql");
      return _graphql_request(file, garpqhlClient, tokenProvider, variables)
    end

    # 这个负责发 query 的 request
    def _graphql_query_request(gql_file_name, garpqhlClient, tokenProvider, variables)
      file = File.open("#{@folder_query}/#{gql_file_name}.gql");
      return _graphql_request(file, garpqhlClient, tokenProvider, variables)
    end

    def _graphql_request(file, garpqhlClient, tokenProvider = nil, variables)
      json = {
        "query": file.read,
        "variables": variables,
      }
      request_params = {
        json: json
      }
      
      # 如果有 token 
      if tokenProvider != nil
        token = tokenProvider.getToken();
        request_params[:token] = token if token
      end

      return garpqhlClient.request(request_params);
    end
    
  end
end