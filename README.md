# custom-social-share

Ti permette di condividere video o immagini direttamente come storie sui social

## Install

```bash
npm install custom-social-share
npx cap sync
```

## API

<docgen-index>

* [`shareToInstagramFromUrl(...)`](#sharetoinstagramfromurl)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### shareToInstagramFromUrl(...)

```typescript
shareToInstagramFromUrl(options: ShareToInstagramOptions) => Promise<void>
```

Condivide su Instagram: storia, post o reel.

| Param         | Type                                                                        |
| ------------- | --------------------------------------------------------------------------- |
| **`options`** | <code><a href="#sharetoinstagramoptions">ShareToInstagramOptions</a></code> |

--------------------


### Interfaces


#### ShareToInstagramOptions

| Prop              | Type                                                                  |
| ----------------- | --------------------------------------------------------------------- |
| **`url`**         | <code>string</code>                                                   |
| **`destination`** | <code><a href="#instagramdestination">InstagramDestination</a></code> |
| **`content_url`** | <code>string</code>                                                   |


### Type Aliases


#### InstagramDestination

<code>'story' | 'post' | 'reel'</code>

</docgen-api>
