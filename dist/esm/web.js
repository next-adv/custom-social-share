import { WebPlugin } from '@capacitor/core';
export class CustomSocialShareWeb extends WebPlugin {
    shareToInstagramFromUrl(options) {
        console.log('CustomSocialShareWeb.shareToInstagramFromUrl', options);
        throw new Error(`Instagram sharing (destination: ${options.destination}) is not available on web.`);
    }
}
//# sourceMappingURL=web.js.map