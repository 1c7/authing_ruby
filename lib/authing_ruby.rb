# 主文件，引入各种东西
require_relative 'authing_ruby/utils/utils' # 工具
require_relative 'authing_ruby/common/PublicKeyManager.rb' # 公钥
require_relative 'authing_ruby/common/GraphqlClient.rb' # 发 GraphQL 请求的工具
require_relative 'authing_ruby/common/HttpClient.rb' # 发 http 请求的工具
require_relative 'authing_ruby/authentication/AuthenticationTokenProvider.rb' # 存 token 和 User

require_relative 'authing_ruby/authentication/AuthenticationClient.rb' 
# AuthenticationClient 以终端用户（End User）的身份进行请求，提供了登录、注册、登出、管理用户资料、获取授权资源等所有管理用户身份的方法；

require_relative 'authing_ruby/management/ManagementClient.rb'
# ManagementClient 以管理员（Administrator）的身份进行请求，用于管理用户池资源和执行管理任务，提供了管理用户、角色、应用、资源等方法；一般来说，你在 Authing 控制台 (opens new window)中能做的所有操作，都能用此模块完成。

# 所有的代码都放在 AuthingRuby 这个 module 下，作为命名空间