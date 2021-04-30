# Authing Ruby SDK
这里是 [Authing](https://www.authing.cn/) 的 Ruby SDK  

## 如何安装
Gemfile 中写上
```
gem "authing_ruby"
```

或者
```
gem install authing_ruby
```

## 基本例子(用户名+密码进行注册)
```ruby
require 'authing_ruby'

options = {
  appId: "appId 填写应用 id, 如 60800b9151d040af9016d60b, 应用->App ID",
  appHost: "appHost 例子: https://rails-demo.authing.cn, 应用->基础设置->认证地址",
}
authenticationClient = AuthingRuby::AuthenticationClient.new(options)
username = "user#{rand(0...9999)}" # 用户名
password = "12345678" # 密码
resp = authenticationClient.registerByUsername(username, password)
puts resp # 返回注册成功的用户信息
```
这个例子来自于 [example/2.registerByUsername.rb](./example/2.registerByUsername.rb)

## 如何使用
1. [`example/`](example/) 目录有使用例子
1. Ruby SDK 是参照 JS SDK 实现的。方法名，参数完全一致，可以翻阅 [JS/Node SDK 文档](https://docs.authing.cn/v2/reference/sdk-for-node/) 参考
1. 也可以参照测试代码 [`lib/test/mini_test/`](./lib/test/mini_test) 进行使用。
1. (关于功能) `1.0.0` 版实现了最常用最基础的功能，而不是 100% 的 Authing API (因为实在太多了)，具体实现了什么功能，参照 [`doc/README.md`](./doc/README.md)
1. 这个 gem 说到底只是一个 SDK，重点是使用 Authing 本身，所以请花些时间阅读 Authing 本身的文档，理解核心概念和流程。

## 当前最新进展：已发布第一版 `1.0.0`

## 时间表
* 发布 `1.1.0` 版：暂无时间计划，先用着当前版本，遇到问题再改，或者等別人发 PR。  
* 发布 `1.0.0` 版：2021-4-30
* 开始时间: 2021-4-22

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
* `doc/` 所有的文档都放在里面
* `example/` 代码例子
* `lib/` 本库的所有源码，包括测试代码。  
* 根目录下的 `.env` 文件都是提供环境变量的

## 假设你要用某个功能, 但发现 Ruby SDK 没有实现，怎么办？
（随便举个例子，比如 Authing JS SDK 里的 "管理用户自定义字段"）

* 解决方法1：(自己实现）fork 一份 Github repo 然后实现，最后发个 PR 合并进来。
* 解决方法2：(提出问题) 在 issue 里发一条，问某功能实现了没有。 
* 解决方法3：(如果实在很急, 等不及方法1里的 PR 合并) fork 完代码实现完之后，自己 publish 一个 gem，名字如 `authing_ruby_fork_[你的名字/公司名/任意名]`，然后用这个新的 gem，后续等 `authing_ruby` gem 合并了你的 PR 再换回来。