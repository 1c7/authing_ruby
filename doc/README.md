## 文档目录
* `doc/` 是给用户看的文档
* `doc/dev/` 是给开发者看的文档  

## 本 gem 实现了哪些功能？
以下列表里有，并且打上勾的，就是已实现的功能。  
如果有，但是没打勾，意思就是正在做。  

## 如何使用这些已实现的功能？
1. 看一下 `example/` 目录里有没有例子。   
2. 在 `lib/test/mini_test/` 里找测试代码。   

# 用户认证模块
## 认证核心模块
- [x] 邮箱+密码注册
- [x] 用户名+密码注册
- [x] 发送短信验证码
- [x] 使用手机号注册
- [x] 使用邮箱登录
- [x] 使用用户名登录
- [x] 使用手机号密码登录
- [x] 使用手机号验证码登录
- [x] 获取当前登录的用户信息
- [x] 退出登录
- [x] 发送邮件
- [x] 检查密码强度
- [x] 检测 Token 登录状态
- [x] 修改用户资料
- [x] 更新用户密码
- [x] 绑定手机号 (用户初次绑定手机号)
- [x] 通过短信验证码重置密码

## [标准协议认证模块](https://docs.authing.cn/v2/reference/sdk-for-node/authentication/StandardProtocol.html)
### OIDC
- [x] 初始化
- [x] 生成 OIDC 协议的用户登录链接
- [x] Code 换 Token
- [x] Token 换用户信息
- [x] 刷新 Access Token
- [x] 检查 Access Token 或 Refresh token 的状态
- [x] 检验 Id Token 或 Access Token 的合法性
- [x] 撤回 Access Token 或 Refresh token
- [x] 生成 PKCE 校验码
- [x] 生成 PKCE 校验码摘要值

## 管理模块
### 管理用户
- [x] 创建用户 
- [x] 修改用户资料
- [x] 通过 ID 获取用户信息
- [x] 删除用户
- [x] 批量删除用户
- [x] 获取用户列表
- [x] 检查用户是否存在
- [x] 查找用户

### 管理应用
- [x] 创建应用：在用户池中创建一个应用
- [x] 删除应用
- [x] 获取应用列表
- [x] [获取应用详情](https://docs.authing.cn/v2/reference/sdk-for-node/management/ApplicationManagementClient.html#%E8%8E%B7%E5%8F%96%E5%BA%94%E7%94%A8%E8%AF%A6%E6%83%85)


## 其他模块
- [x] [使用指南 -> 常见问题 -> 如何验证用户身份凭证（token） -> 使用应用密钥验证 HS256 算法签名的 Token](https://docs.authing.cn/v2/guides/faqs/how-to-validate-user-token.html#%E4%BD%BF%E7%94%A8%E5%BA%94%E7%94%A8%E5%AF%86%E9%92%A5%E9%AA%8C%E8%AF%81-hs256-%E7%AE%97%E6%B3%95%E7%AD%BE%E5%90%8D%E7%9A%84-token) - 参考代码 `example/15.verify_id_token_locally_with_SDK.rb`

---

## TODO 待办事项（接下来要做的）
- [ ] [使用指南 -> 常见问题 -> 如何验证用户身份凭证（token）-> 使用应用公钥验证 RS256 算法签名的 IdToken](https://docs.authing.cn/v2/guides/faqs/how-to-validate-user-token.html#%E4%BD%BF%E7%94%A8%E5%BA%94%E7%94%A8%E5%85%AC%E9%92%A5%E9%AA%8C%E8%AF%81-rs256-%E7%AE%97%E6%B3%95%E7%AD%BE%E5%90%8D%E7%9A%84-idtoken)

## 如何参与本 gem 的开发
* 可以在 issue 中留下你的微信，或通过其他渠道和我取得联系（QQ `1003211008`/ 邮件 `chengzheng.apply@gmail.com`）
* 对于大的改动，最好先讨论然后再发 Pull Request
* 对于小的改动，比如只改了几行代码，或改了几行文档，那就可以直接发 PR，无需事先讨论

## Gem 作者
（截止至2021-4-30）这个 Ruby Gem 非 Authing 官方出品，是社区写的。        
因为我需要在 Ruby on Rails 项目里用 Authing 做身份管理，所以写这个 gem。   
以后有可能和 Authing 工作人员共同维护，变成官方+社区一起维护。   
我们目前有一个 `Authing Ruby SDK 开发小组` 的6人微信聊天群。   

## 目录结构
* `doc/` 文档
* `example/` 例子
* `lib/` 所有源码，包括测试代码。  
* 根目录下的 `.env` 文件是提供环境变量的

## 假设你要用某个功能, 但发现 Ruby SDK 没有实现，怎么办？
（举个例子，比如 Authing JS SDK 里的 "管理用户自定义字段"）

* 解决方法1：(自己实现）fork 一份 Github repo 然后实现，最后发个 PR 合并进来。
* 解决方法2：(提出问题) 在 issue 里发一条，问某功能实现了没有。 
* 解决方法3：(如果实在很急, 等不及方法1里的 PR 合并) fork 完代码实现完之后，自己 publish 一个 gem，名字如 `authing_ruby_fork_[你的名字/公司名/任意名]`，然后用这个新的 gem，后续等 `authing_ruby` gem 合并了你的 PR 再换回来。