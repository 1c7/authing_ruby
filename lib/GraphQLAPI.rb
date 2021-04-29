# 类似于 JS SDK 里 src/lib/graphqlapi.ts 的用途
# 把一些 garpqhlClient.request 封装起来，里面包含了 const query = AccessTokenDocument;

# 使用示例
# graphqlAPI = AuthingRuby::GraphQLAPI.new
# graphqlAPI.getAccessToken(graphqlClient, variables)

module AuthingRuby
  class GraphQLAPI

    def initialize()
      @folder_graphql = "./lib/graphql"
      @folder_mutation = "#{@folder_graphql}/mutations"
      @folder_query = "#{@folder_graphql}/queries"
    end

    def getAccessToken(garpqhlClient, variables)
      file = File.open("#{@folder_query}/accessToken.gql");
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json})
    end

    def refreshAccessToken(garpqhlClient, variables)
      file = File.open("#{@folder_mutation}/refreshAccessToken.gql");
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json})
    end

    def createUser(garpqhlClient, tokenProvider = nil, variables = nil)
      file = File.open("#{@folder_mutation}/createUser.gql");
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
    end

    def updateUser(garpqhlClient, tokenProvider = nil, variables = nil)
      file = File.open("#{@folder_mutation}/updateUser.gql");
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
    end

    def user(garpqhlClient, tokenProvider = nil, variables = nil)
      file = File.open("#{@folder_query}/user.gql");
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
    end

    def deleteUser(garpqhlClient, tokenProvider = nil, variables = nil)
      file = File.open("#{@folder_mutation}/deleteUser.gql");
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
    end

    def deleteUsers(garpqhlClient, tokenProvider = nil, variables = nil)
      file = File.open("#{@folder_mutation}/deleteUsers.gql");
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
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

    # 太多同样写法的 method 了，稍微抽象一下
    # 这个负责发 mutation 的 request
    def _graphql_mutation_request(gql_file_name, garpqhlClient, tokenProvider, variables)
      file = File.open("#{@folder_mutation}/#{gql_file_name}.gql");
      return _graphql_request(file, garpqhlClient, tokenProvider, variables)
    end

    # 这个负责发 query 的 request
    def _graphql_query_request(gql_file_name, garpqhlClient, tokenProvider, variables)
      file = File.open("#{@folder_query}/#{gql_file_name}.gql");
      return _graphql_request(file, garpqhlClient, tokenProvider, variables)
    end

    def _graphql_request(file, garpqhlClient, tokenProvider, variables)
      token = tokenProvider.getToken();
      json = {
        "query": file.read,
        "variables": variables,
      }
      return garpqhlClient.request({json: json, token: token});
    end
    
  end
end