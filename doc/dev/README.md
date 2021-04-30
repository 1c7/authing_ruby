## 文档目录
这个 `doc/dev/` 目录是给 gem 的开发者看的。  

* [Authing 相关](./1.Authing.md)
* [更新日志](./2.Changelog.md)
* [测试](./3.Test.md)
* [如何发布 gem 的新版本？](./4.HowToUpdate.md)

## 为什么写这个 gem，官方不提供吗？
截止至2021年4月中旬，   
虽然官方文档里有 [Ruby SDK](https://docs.authing.cn/v2/reference/sdk-for-ruby.html)  
但实测无法使用。  
经过在微信上询问官方工作人员，回复是

> 你好，收到反馈，ruby 的用户比例较少，当前确实较少维护。
我们建议和社区一起做一下，如果您有兴趣参与，我们会非常感激

## 做事方法
* Authing 的诸多 SDK 里，更新最频繁的是 [Javascript/Node.js SDK](https://github.com/authing/authing.js)，所以 Ruby SDK 里会参照 JS SDK 的做法和写法。反正用法是一样的，写法也尽量一样 (方法的命名和参数)

## 参与开发这个 gem 的前提要求
1. 对 GraphQL 有基础了解
2. 对 Ruby Gem 的文件夹结构有基础了解
3. 粗略翻阅过 Authing 的官方文档

## 提示：开发时可以参考其他语言的 SDK：
* [authing.js](https://github.com/Authing/authing.js)