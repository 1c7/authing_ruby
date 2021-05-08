# Authing Ruby SDK - [Ruby Gems 地址](https://rubygems.org/gems/authing_ruby)
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
1. 目前实现了最常用最基础的功能，而不是 100% 的 Authing API (因为实在太多)，具体实现了什么功能，参照 [`doc/README.md`](./doc/README.md)
1. 这个 gem 说到底只是一个工具，重点是使用 Authing 本身，所以务必阅读 Authing 的文档，理解核心概念

## 时间表
* 发布 `1.0.7` 版：2021-5
* 发布 `1.0.0` 版：2021-4-30
* 写下第一行代码: 2021-4-22

---

### [更多文档请阅读](doc/)

## 补充说明
这个 gem 可以单独使用，但如果你希望在 `Ruby on Rails` 项目中使用这个 Ruby SDK，希望找一些例子参考。  
可以看： https://github.com/1c7/authing_ruby_rails_example