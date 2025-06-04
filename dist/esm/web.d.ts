import { WebPlugin } from '@capacitor/core';
import type { CustomSocialSharePlugin, ShareToFacebookOptions, ShareToInstagramOptions } from './definitions';
export declare class CustomSocialShareWeb extends WebPlugin implements CustomSocialSharePlugin {
    shareToInstagramFromUrl(options: ShareToInstagramOptions): Promise<void>;
    shareToFacebookFromUrl(options: ShareToFacebookOptions): Promise<void>;
}
