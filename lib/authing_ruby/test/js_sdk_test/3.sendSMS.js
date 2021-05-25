// 做一些其他测试时，需要发短信验证码
// 单独用这个文件做
// 如何运行
// node ./lib/authing_ruby/test/js_sdk_test/3.sendSMS.js

// 初始化
const { AuthenticationClient } = require("authing-js-sdk");
const authenticationClient = new AuthenticationClient({
  appId: "60ab26fe5be730bfc1742c68",
  appHost: "https://hn-staging.authing.cn",
});

// 手机号
phone = "13556136684";

// 调用接口发送
authenticationClient.sendSmsCode(phone)
  .then((r) => {
    console.log(r);
  })
  .catch((e) => {
    console.log(e);
  });
