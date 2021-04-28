# 类似于 JS SDK 里 src/lib/graphqlapi.ts 的用途
# 把一些 garpqhlClient.request 封装起来，里面包含了 const query = AccessTokenDocument;

# 使用示例
# graphqlAPI = AuthingRuby::GraphQLAPI.new
# graphqlAPI.getAccessToken(graphqlClient, variables)

module AuthingRuby
	class GraphQLAPI

		def initialize()
      @folder_graphql = "./lib/graphql"
      @folder_graphql_mutation = "#{@folder_graphql}/mutations"
      @folder_graphql_query = "#{@folder_graphql}/queries"
		end

		def getAccessToken(garpqhlClient, variables)
			file = File.open("#{@folder_graphql_query}/accessToken.gql");
      json = {
        "query": file.read,
        "variables": variables,
      }
			return garpqhlClient.request({json: json})
		end

	end
end