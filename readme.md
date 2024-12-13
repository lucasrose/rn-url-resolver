## React Native Url Resolver
This is an expo module which will resolve a url to its final destination. It is useful for resolving tracking links (ie. Sendgrid https://www.twilio.com/docs/sendgrid/ui/sending-email/universal-links#using-java)

### Installation
1. Install `npm install rn-url-resolver`
2. If deep linking is necessary, host the correct aasa for the subdomain and add the correct associated domains & intent filters ie. `tracking-link.example.com` to your `app.json`

For iOS
```json
"associatedDomains": ["applinks:tracking-link.example.com"]
```

For Android
```json
"intentFilters": [
    {
      "action": "VIEW",
      "autoVerify": true,
      "category": ["BROWSABLE", "DEFAULT"],
      "data": [
        {
          "scheme": "https", // or "http"
          "host": "tracking-link.example.com",
          "pathPrefix": "/"
        }
      ]
    }
  ]
```
3. Run expo prebuild `npx expo prebuild`.

### Usage

```typescript
import RnUrlResolver from "rn-url-resolver";
```
- Resolve the url

```typescript
const url = "https://tracking-link.example.com/ls/click?123456";
const token: string | undefined = 'example-token';
const resolvedUrl = await RnUrlResolver.resolveUrl({ url, token, allowReturnFromFailedUrl: boolean });

```
The `token` parameter is optional and defaults to `undefined`.
The `allowReturnFromFailedUrl` parameter is optional and defaults to `false`. Only for iOS. If set to `true`, the url will be returned even when there is an `NSErrorFailingURLStringKey`.
Note: You may need to specify some info.plist settings for this setting to actually work. Here's an example config for expo:

```typescript
ios: {
  infoPlist: {
        NSAppTransportSecurity: {
          NSAllowsArbitraryLoads: false,
          NSExceptionDomains:[
            ['example.com']: {
              NSExceptionAllowsInsecureHTTPLoads: true,
              NSIncludesSubdomains: false,
            },
          ],
        }
  },
}
```
