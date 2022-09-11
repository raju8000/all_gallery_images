import 'package:all_gallery_images/all_gallery_images.dart';
import 'package:all_gallery_images/model/StorageImages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:all_gallery_images/all_gallery_images_method_channel.dart';

void main() {
  MethodChannelAllGalleryImages platform = MethodChannelAllGalleryImages();
  const MethodChannel channel = MethodChannel('plugins.io/gallery_images');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if(methodCall.method == 'getAllImagesFromStorage'){
        return [{}];
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getGalleryImages', () async {
    expect(await GalleryImages().getStorageImages(), isInstanceOf<StorageImages>());
  });
}
