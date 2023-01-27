import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'all_gallery_images_platform_interface.dart';
import 'model/StorageImages.dart';

/// An implementation of [AllGalleryImagesPlatform] that uses method channels.
class MethodChannelAllGalleryImages extends AllGalleryImagesPlatform {
  static const CHANNEL_NAME = "plugins.io/all_gallery_images";

  @visibleForTesting
  final methodChannel = const MethodChannel(CHANNEL_NAME);

  @override
  Future<StorageImages?> getStorageImages() async {
    final allImages = await methodChannel
        .invokeMethod<List<dynamic>>('getAllImagesFromStorage');
    try {
      if (allImages != null) {
        return StorageImages.fromJson(allImages);
      }
      return null;
    } catch (error) {
      if (allImages![0] == "Permissions Not Granted") {
        log(' GALLERY IMAGES: Storage Permissions Not Granted');
      }
      return null;
    }
  }
}
