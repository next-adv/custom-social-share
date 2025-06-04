export type InstagramDestination = 'story' | 'post' | 'reel';
export type FacebookDestination = 'story' | 'post' | 'reel';

export interface ShareToInstagramOptions {
    url: string; // URL dell'immagine o video remoto
    destination: InstagramDestination;
    content_url?: string; // solo per le storie
}

export interface ShareToFacebookOptions {
    url: string; // URL dell'immagine o video remoto
    destination: InstagramDestination;
    content_url?: string; // solo per le storie
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
