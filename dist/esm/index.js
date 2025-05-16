import { registerPlugin } from '@capacitor/core';
const CustomSocialShare = registerPlugin('CustomSocialShare', {
    web: () => import('./web').then((m) => new m.CustomSocialShareWeb()),
});
export * from './definitions';
export { CustomSocialShare };
//# sourceMappingURL=index.js.map