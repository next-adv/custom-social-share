#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CustomSocialSharePlugin, "CustomSocialShare",
  CAP_PLUGIN_METHOD(shareToInstagramFromUrl, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(shareToFacebookFromUrl, CAPPluginReturnPromise);
)