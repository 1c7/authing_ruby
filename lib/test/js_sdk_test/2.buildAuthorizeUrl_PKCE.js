// 如何运行: 
// node ./lib/test/js_sdk_test/2.buildAuthorizeUrl_PKCE.js
const { AuthenticationClient } = require('authing-js-sdk')

// 测试目的: 生成 OIDC 协议的用户登录链接
const client = new AuthenticationClient({
  appId: '60800b9151d040af9016d60b',
  appHost: 'https://rails-demo.authing.cn',
  redirectUri: 'http://localhost:3000/authing_callback',
});

// PKCE 场景使用示例
// 生成一个 code_verifier
let codeChallenge = client.generateCodeChallenge()
// 计算 code_verifier 的 SHA256 摘要
let codeChallengeDigest = client.getCodeChallengeDigest({ codeChallenge, method: 'S256' })
// 构造 OIDC 授权码 + PKCE 模式登录 URL
let url2 = client.buildAuthorizeUrl({ codeChallenge: codeChallengeDigest, codeChallengeMethod: 'S256' });
console.log(url2)
// https://rails-demo.authing.cn/oidc/auth?nonce=8366121074426842&state=8460658619689978&scope=openid+profile+email+phone+address&client_id=60800b9151d040af9016d60b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthing_callback&response_type=code&code_challenge=LtE99dfPutuMXGSMCzKsbeTTCGlwmUi9sbQDFDZbB20&code_challenge_method=S256

// 分析 JS SDK 生成的：
// https://rails-demo.authing.cn/oidc/auth?
// nonce=8366121074426842
// &state=8460658619689978
// &scope=openid+profile+email+phone+address
// &client_id=60800b9151d040af9016d60b
// &redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthing_callback
// &response_type=code
// &code_challenge=LtE99dfPutuMXGSMCzKsbeTTCGlwmUi9sbQDFDZbB20
// &code_challenge_method=S256

// 我们 Ruby SDK 生成的
// https://rails-demo.authing.cn/oidc/auth?
// nonce=1232057194833633
// &state=3333848247084549
// &scope=openid%20profile%20email%20phone%20address
// &client_id=60800b9151d040af9016d60b
// &redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthing_callback
// &response_type=code
// &code_challenge=NGZkOTJiMjYzY2Q3NTkzMjM5YTE5N2E3NTUyOGFiYWZiM2MzOTE0NmIyYTY1%0AYzE2YzYxMjRmYzczNjM5YTljMw%0A
// &code_challenge_method=S256

// 区别:
// 1. scope 不同
// 2. 我的少了 code_challenge
// 3. 我的少了 code_challenge_method
