# 管理角色
# TODO: 这个只写了个架子，具体的还没实现

module AuthingRuby
  class RolesManagementClient

    def initialize(options = {}, graphqlClient = nil, tokenProvider = nil)
      @options = options
      @graphqlClient = graphqlClient
      @tokenProvider = tokenProvider
    end

    # 创建角色
    def create
    end

    # 删除角色
    def delete
    end

    # 修改角色
    def update
    end

    # 获取角色列表
    def list
    end

    # 添加用户
    def addUsers
    end

    # 移除用户
    def removeUsers
    end
    
  end
end