# 之前试验 graphql client 发请求的代码不太好用，官方文档我没太看懂。反正代码先暂时在这里放着，后续有需要参考再参考。

# require "graphql/client"
# require "graphql/client/http"

# 这个能用：
# GraphQL::Client.dump_schema(API::HTTP, './api/schema.json')
# https://github.com/github/graphql-client
# module API
#   HTTP = GraphQL::Client::HTTP.new('https://core.authing.cn/graphql')
#   Schema = GraphQL::Client.load_schema(HTTP)
#   Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
# end