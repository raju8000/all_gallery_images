# All Gallery Images

[![pub package](https://img.shields.io/pub/v/all_gallery_images.svg)](https://pub.dev/packages/all_gallery_images)

Flutter plugin use to fetch all the images from the storage in Android and iOS .


## Installation

First, add all_gallery_images as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

#### iOS
Add the following keys to your *Info.plist* file :

```NSPhotoLibraryUsageDescription``` - describe why your app needs permission for the photo library. This is called *Privacy - Photo Library Usage Description* in the visual editor.

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow assess in order to fetch images from storage</string>
```

#### Android
Add the following permissions to your *AndroidManifest.xml* :

```xml
<manifest ...>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    ...
<manifest/>
```
### Example

``` dart

    ...
    StorageImages? storageImages;
        try {
          storageImages = await GalleryImages().getStorageImages();
        } catch(error)
        {
          debugPrint(error.toString());
        }
    ...
```