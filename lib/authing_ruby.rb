# 引入各种东西
require './lib/utils/utils.rb' # 工具
require './lib/common/PublicKeyManager.rb' # 公钥
require './lib/common/GraphqlClient.rb' # 发 GraphQL 请求的工具
require './lib/authentication/AuthenticationTokenProvider.rb' # 存 token 和 User

require './lib/authentication/AuthenticationClient.rb' 
# AuthenticationClient 以终端用户（End User）的身份进行请求，提供了登录、注册、登出、管理用户资料、获取授权资源等所有管理用户身份的方法；

require './lib/management/ManagementClient.rb'
# ManagementClient 以管理员（Administrator）的身份进行请求，用于管理用户池资源和执行管理任务，提供了管理用户、角色、应用、资源等方法；一般来说，你在 Authing 控制台 (opens new window)中能做的所有操作，都能用此模块完成。