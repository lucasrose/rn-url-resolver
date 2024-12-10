## React Native Url Resolver
This is an expo module which will resolve a url to its final destination. It is useful for resolving tracking links (ie. Sendgrid https://www.twilio.com/docs/sendgrid/ui/sending-email/universal-links#using-java)

### Installation
1. Install `npm install rn-url-resolver`
2. If deep linking is necessary, add the correct associated domains & intent filters `tracking-link.example.com` to your `app.json`

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
          "scheme": "https",
          "host": "tracking-link.example.com",
          "pathPrefix": "/"
        }
      ]
    }
  ]
```
3. Run expo prebuild `npx expo prebuild`.

### Usage

There's an optional token parameter which can be included to authenticate a request (using bearer auth) if necessary.
```typescript
import RnUrlResolver from "rn-url-resolver";
```
- Resolve the url
```typescript
const url = "https://tracking-link.example.com/ls/click?123456";
const token: string | undefined = 'example-token';
const resolvedUrl = await RnUrlResolver.resolveUrl(url, token);
```
```typescript
  const url = Linking.useURL();

  const parsedUrl = await RnUrlResolver.resolveUrl(url);
  if (parsedUrl) {
    // Handle the url
  }
```

