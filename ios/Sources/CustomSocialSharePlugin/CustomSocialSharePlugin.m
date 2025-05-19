#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CustomSocialSharePlugin, "CustomSocialShare",
  CAP_PLUGIN_METHOD(shareToInstagramFromUrl, CAPPluginReturnPromise);
)
