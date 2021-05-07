## 说明
`example/` 目录存放例子

## 运行前注意
先修改根目录下 `.env.example` 文件，提供配置信息。  
建议您新建一个全新的`用户池`，专门用于运行例子，因为例子里会演示"注册,登录"等操作。     
然后把信息填入 `.env.example`

## 列表
* [注册: 邮箱+密码](./1.registerByEmail.rb)
* [注册: 用户名+密码](./2.registerByUsername.rb)
* [发送手机验证码](./3.sendSmsCode.rb)
* [注册: 手机号+验证码+密码](./5.registerByPhoneCode.rb)
* [发送邮件](./4.sendEmail.rb)
* [登录: 邮箱+密码](6.loginByEmail.rb)
