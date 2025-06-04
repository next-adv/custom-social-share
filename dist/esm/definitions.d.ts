export declare type InstagramDestination = 'story' | 'post' | 'reel';
export declare type FacebookDestination = 'story' | 'post' | 'reel';
export interface ShareToInstagramOptions {
    url: string;
    destination: InstagramDestination;
    content_url?: string;
}
export interface ShareToFacebookOptions {
    url: string;
    destination: FacebookDestination;
    content_url?: string;
}
export interface CustomSocialSharePlugin {
    /**
     * Condivide su Instagram: storia, post o reel.
     */
    shareToInstagramFromUrl(options: ShareToInstagramOptions): Promise<void>;
    /**
     * Condivide su Facebook: storia, post o reel.
     */
    shareToFacebookFromUrl(options: ShareToFacebookOptions): Promise<void>;
}
