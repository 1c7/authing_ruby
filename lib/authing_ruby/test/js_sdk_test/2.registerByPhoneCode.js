// 测试 registerByPhoneCode 这个接口在失败情况下的返回
// 因为 2021年5月25号，JS SDK 的文档没写，既然没写我们就只能试一试了
// 如何运行:
// node ./lib/authing_ruby/test/js_sdk_test/2.registerByPhoneCode.js

const { AuthenticationClient } = require("authing-js-sdk");
const authenticationClient = new AuthenticationClient({
  appId: "60ab26fe5be730bfc1742c68",
  appHost: "https://hn-staging.authing.cn",
});

// 官网文档的例子
async function test() {
	phone = "13556136684"
	code = "7965"
	password = "123456789"
  return await authenticationClient.registerByPhoneCode(
    phone,
    code,
    password,
    {
      nickname: "Nick",
      company: "蒸汽记忆",
    }
  );
}

/*
错误情况1，假设 appid 是瞎填或填错了，会报错：
{
  code: 500,
  message: 'Could not find any entity of type "Application" matching: "60800b9151d040af9016d60b"',
  data: undefined
}
*/

/*
错误情况2：验证码
{ code: 2001, message: '验证码不正确！', data: undefined }

注意：哪怕手机号乱填，写成 "a"，或者留空 ""，或者瞎填 "183618318631836138"，都会是这个错误
*/

/*
假设手机号+验证码正确。密码留空：
password = ""
也可以注册成功，返回
{
  id: '60acfd72746095b279b6c330',
  arn: 'arn:cn:authing:60ab26fe478f98290befefaa:user:60acfd72746095b279b6c330',
  userPoolId: '60ab26fe478f98290befefaa',
  status: 'Activated',
  username: null,
  email: null,
  emailVerified: false,
  phone: '13556136684',
  phoneVerified: true,
  unionid: null,
  openid: null,
  nickname: 'Nick',
  registerSource: [ 'basic:phone-code' ],
  photo: 'default-user-avatar.png',
  password: '',
  oauth: null,
  token: null,
  tokenExpiredAt: null,
  loginsCount: 0,
  lastLogin: null,
  lastIP: null,
  signedUp: null,
  blocked: false,
  isDeleted: false,
  device: null,
  browser: null,
  company: '蒸汽记忆',
  name: null,
  givenName: null,
  familyName: null,
  middleName: null,
  profile: null,
  preferredUsername: null,
  website: null,
  gender: 'U',
  birthdate: null,
  zoneinfo: null,
  locale: null,
  address: null,
  formatted: null,
  streetAddress: null,
  locality: null,
  region: null,
  postalCode: null,
  city: null,
  province: null,
  country: null,
  createdAt: '2021-05-25T13:36:50+00:00',
  updatedAt: '2021-05-25T13:36:50+00:00',
  externalId: null
}
*/


/*
假设前面的账户不删，再来一次，这一次密码写成：
password = "123456789"

会返回
{ code: 2001, message: '验证码不正确！', data: undefined }
估计是用一次之后这个验证码就失效了，


那么我们再发一次短信，再试试 password = "123456789"
这一次会返回
{ code: 2026, message: '用户已存在，请直接登录！', data: undefined }
*/

test()
  .then((r) => {
    console.log(r);
  })
  .catch((e) => {
    console.log(e);
  });
