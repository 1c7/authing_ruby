# 管理资源与权限
# src/lib/management/AclManagementClient.ts

module AuthingRuby
  class AclManagementClient

    def initialize(options = {}, graphqlClient = nil, httpClient = nil, tokenProvider = nil)
      @options = options
      @graphqlClient = graphqlClient
      @httpClient = httpClient
      @tokenProvider = tokenProvider
    end

    def isAllowed
    end

    # 创建权限分组
    def createNamespace
    end

    # 获取权限分组列表
    def listNamespaces
    end

    # 删除权限分组
    def deleteNamespace
    end

    # 获取资源列表
    def listResources
    end

    # 创建资源
    def createResource
    end

    # 更新资源
    def updateResource
    end

    # 删除资源
    def deleteResource
    end


  end
end