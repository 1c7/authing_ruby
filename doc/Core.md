

## AuthenticationClient
使用示例
```ruby
authing = AuthingRuby::AuthenticationClient.new({

})
```

参照自
```javascript
import { AuthenticationClient } from 'authing-js-sdk';
const authenticationClient = new AuthenticationClient({
	appId: '应用 ID',
	secret: '应用密钥',
	appHost: 'https://{YOUR_DOMAIN}.authing.cn',
	redirectUri: '业务回调地址',
});
let res = await authenticationClient.getAccessTokenByCode('授权码 code');
```
