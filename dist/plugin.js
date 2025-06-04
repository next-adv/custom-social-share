var customSocialShare = (function (exports, core) {
    'use strict';

    const CustomSocialShare = core.registerPlugin('CustomSocialShare', {
        web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.CustomSocialShareWeb()),
    });

    class CustomSocialShareWeb extends core.WebPlugin {
        shareToInstagramFromUrl(options) {
            console.log('CustomSocialShareWeb.shareToInstagramFromUrl', options);
            throw new Error(`Instagram sharing (destination: ${options.destination}) is not available on web.`);
        }
        shareToFacebookFromUrl(options) {
            console.log('CustomSocialShareWeb.shareToFacebookFromUrl', options);
            throw new Error(`Facebook sharing (destination: ${options.destination}) is not available on web.`);
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        CustomSocialShareWeb: CustomSocialShareWeb
    });

    exports.CustomSocialShare = CustomSocialShare;

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
