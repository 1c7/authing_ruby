## 说明
`example/` 目录存放例子

## 运行前注意
先修改根目录下 `.env.example` 文件，提供配置信息。  
建议您新建一个全新的`用户池`，专门用于运行例子，因为例子里会演示"注册,登录"等操作。     

## 列表
* [通过邮箱+密码注册](./1.registerByEmail.rb)
* [通过用户名+密码注册](./2.registerByUsername.rb)
* [发送手机验证码](./3.sendSmsCode.rb)
* [发送邮件](./4.sendEmail.rb)

实现代码+测试代码写多了，累了，不想写那么多例子，  
其他的可以参考 `lib/test/mini_test`