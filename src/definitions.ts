export type InstagramDestination = 'story' | 'post' | 'reel';

export interface ShareToInstagramOptions {
    url: string; // URL dell'immagine o video remoto
    destination: InstagramDestination;
    content_url?: string; // solo per le storie
}

export interface CustomSocialSharePlugin {
    /**
     * Condivide su Instagram: storia, post o reel.
     */
    shareToInstagramFromUrl(options: ShareToInstagramOptions): Promise<void>;
}
