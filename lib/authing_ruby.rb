require './lib/utils/utils.rb' # 工具
require './lib/common/PublicKeyManager.rb' # 公钥
require './lib/common/GraphqlClient.rb' # 发 GraphQL 请求的工具
require './lib/authentication/AuthenticationTokenProvider.rb' # 存 token 和 User
require './lib/authentication/AuthenticationClient.rb'
require './lib/management/ManagementClient.rb'

# 这里引入各种需要的东西