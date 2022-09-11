#import "AllGalleryImagesPlugin.h"
#if __has_include(<all_gallery_images/all_gallery_images-Swift.h>)
#import <all_gallery_images/all_gallery_images-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "all_gallery_images-Swift.h"
#endif

@implementation AllGalleryImagesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAllGalleryImagesPlugin registerWithRegistrar:registrar];
}
@end
