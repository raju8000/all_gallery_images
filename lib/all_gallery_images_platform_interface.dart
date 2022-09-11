import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'all_gallery_images_method_channel.dart';
import 'model/StorageImages.dart';

abstract class AllGalleryImagesPlatform extends PlatformInterface {
  /// Constructs a AllGalleryImagesPlatform.
  AllGalleryImagesPlatform() : super(token: _token);

  static final Object _token = Object();

  static AllGalleryImagesPlatform _instance = MethodChannelAllGalleryImages();

  /// The default instance of [AllGalleryImagesPlatform] to use.
  ///
  /// Defaults to [MethodChannelAllGalleryImages].
  static AllGalleryImagesPlatform get instance => _instance;

  static set instance(AllGalleryImagesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<StorageImages?> getStorageImages() {
    throw UnimplementedError('getStorageImages() has not been implemented.');
  }
}
