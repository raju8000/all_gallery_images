
import 'all_gallery_images_platform_interface.dart';
import 'model/StorageImages.dart';

class GalleryImages {
  Future<StorageImages?> getStorageImages() {
    return AllGalleryImagesPlatform.instance.getStorageImages();
  }
}
