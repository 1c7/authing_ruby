// 如何运行: 
// node ./lib/test/js_sdk_test/1.buildAuthorizeUrl.js
const { AuthenticationClient } = require('authing-js-sdk')

// 测试目的: 生成 OIDC 协议的用户登录链接
const client = new AuthenticationClient({
  appId: '60800b9151d040af9016d60b',
  appHost: 'https://rails-demo.authing.cn',
  redirectUri: 'http://localhost:3000/authing_callback',
});
let url = client.buildAuthorizeUrl({ scope: 'openid profile offline_access' });
console.log(url);
// 把这个 url 复制粘贴到浏览器里
// https://rails-demo.authing.cn/oidc/auth?nonce=42585064286980057&state=939818283327392&scope=openid+profile+offline_access&client_id=60800b9151d040af9016d60b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthing_callback&response_type=code&prompt=consent