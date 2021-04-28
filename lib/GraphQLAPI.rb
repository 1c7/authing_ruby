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

  end
end