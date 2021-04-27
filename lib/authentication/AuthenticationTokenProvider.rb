# 这个 class 只是存取 token 和 user
# 参照 JS SDK 实现的
# authing.js/src/lib/authentication/AuthenticationTokenProvider.ts 
# https://github.com/Authing/authing.js/blob/196b33fe0c7f510ca26cda4d172939e1c74cc5f7/src/lib/authentication/AuthenticationTokenProvider.ts#L7

module Authentication
  class AuthenticationTokenProvider
    def initialize()
      @token = nil
      @user = nil
    end

    def setToken(token = nil)
      if token
        @token = token
      end
    end

    def getToken()
      return @token
    end

    def getUser()
      return @user
    end

    def setUser(user = nil)
      if user
        @user = user
        @token = user['token']
      end
    end

    def clearUser()
      @token = nil
      @user = nil
    end

  end
end
