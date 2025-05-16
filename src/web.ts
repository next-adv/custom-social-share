import {WebPlugin} from '@capacitor/core';

import type {CustomSocialSharePlugin, ShareToInstagramOptions} from './definitions';

export class CustomSocialShareWeb extends WebPlugin implements CustomSocialSharePlugin {
    shareToInstagramFromUrl(options: ShareToInstagramOptions): Promise<void> {
        console.log('CustomSocialShareWeb.shareToInstagramFromUrl', options);
        throw new Error(`Instagram sharing (destination: ${options.destination}) is not available on web.`);
    }
}
