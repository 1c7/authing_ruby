# Authing Ruby SDK
这里是 [Authing](https://www.authing.cn/) 的 Ruby SDK。    
非官方，社区写的。     
因为我需要在 Ruby on Rails 项目里使用 Authing 做身份管理，所以写这个 gem。

## 当前进展：开发中

## 为什么写这个 gem，官方不提供吗？
截止至2021年4月，   
虽然官方文档里有 [Ruby SDK](https://docs.authing.cn/v2/reference/sdk-for-ruby.html)  
但实测无法使用。  
经过在微信上询问官方工作人员，回复是

> 你好，收到反馈，ruby 的用户比例较少，当前确实较少维护。
我们建议和社区一起做一下，如果您有兴趣参与，我们会非常感激

## 做事方法
* Authing 的诸多 SDK 里，更新最频繁的是 `Javascript/Node.js` SDK，所以 Ruby SDK 里会参照 JS SDK 的做法和写法。反正用法是一样的，写法也尽量一样。

模块列表
AuthenticationClient 核心模块
QrCodeAuthenticationClient 小程序扫码登录和 APP 扫码登录
MfaAuthenticationClient 多因素认证模块
SocialAuthenticationClient 社会化登录模块