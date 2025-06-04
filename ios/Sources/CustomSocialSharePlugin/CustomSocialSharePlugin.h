// CustomSocialSharePlugin.h

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(CustomSocialShare, "CustomSocialShare",
  CAP_PLUGIN_METHOD(shareToInstagramFromUrl, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(shareToFacebookFromUrl, CAPPluginReturnPromise);
)
