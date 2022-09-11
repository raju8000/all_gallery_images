import 'package:all_gallery_images/model/StorageImages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:all_gallery_images/all_gallery_images.dart';
import 'package:all_gallery_images/all_gallery_images_platform_interface.dart';
import 'package:all_gallery_images/all_gallery_images_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAllGalleryImagesPlatform 
    with MockPlatformInterfaceMixin
    implements AllGalleryImagesPlatform {

  @override
  @override
  Future<StorageImages?> getStorageImages() => Future.value();

}

void main() {
  final AllGalleryImagesPlatform initialPlatform = AllGalleryImagesPlatform.instance;

  test('$MethodChannelAllGalleryImages is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAllGalleryImages>());
  });

  test('getPlatformVersion', () async {
    GalleryImages allGalleryImagesPlugin = GalleryImages();
    MockAllGalleryImagesPlatform fakePlatform = MockAllGalleryImagesPlatform();
    AllGalleryImagesPlatform.instance = fakePlatform;

    expect(await allGalleryImagesPlugin.getStorageImages(), isInstanceOf<StorageImages>());
  });
}
