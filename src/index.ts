import {registerPlugin} from '@capacitor/core';

import type {CustomSocialSharePlugin} from './definitions';

const CustomSocialShare = registerPlugin<CustomSocialSharePlugin>('CustomSocialShare', {
    web: () => import('./web').then((m) => new m.CustomSocialShareWeb()),
});

export * from './definitions';
export {CustomSocialShare};
