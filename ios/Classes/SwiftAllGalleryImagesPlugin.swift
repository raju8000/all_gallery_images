import Flutter
import UIKit
import Photos

public class SwiftAllGalleryImagesPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {

    let CHANNEL_NAME = "plugins.io/all_gallery_images"
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftAllGalleryImagesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getAllImagesFromStorage") {
        getAllIMages(result:result)
    }
  }

  func getAllIMages(result: @escaping FlutterResult){
        DispatchQueue.main.async {

              PHPhotoLibrary.execute(onAccessHasBeenGranted: {
                  // access granted...
                  let imgManager = PHImageManager.default()
                  let requestOptions = PHImageRequestOptions()
                  requestOptions.isSynchronous = true
                  let fetchOptions = PHFetchOptions()
                  fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]

                  let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                  var allImageInfoList  = [Any]()

                  var totalIteration = 0
                  print("fetchResult.count : \(fetchResult.count)")

                  var savedLocalIdentifiers = [String]()

                  for index in 0..<fetchResult.count
                  {
                      let asset = fetchResult.object(at: index) as PHAsset
                      let localIdentifier = asset.localIdentifier
                      savedLocalIdentifiers.append(localIdentifier)

                      let options: PHImageRequestOptions = PHImageRequestOptions()
                              options.resizeMode = .exact
                              options.deliveryMode = .highQualityFormat
                      imgManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFit, options: options, resultHandler:{(image, info) in

                          if image != nil {
                              var imageData: Data?
                              if let cgImage = image!.cgImage, cgImage.renderingIntent == .defaultIntent {
                                  imageData =  image!.jpegData(compressionQuality: 0.8)
                              }
                              else {
                                  imageData =   image!.pngData()
                              }
                              let guid = ProcessInfo.processInfo.globallyUniqueString;
                              let tmpFile = String(format: "gallery_images_%@.jpg", guid);
                              let tmpDirectory = NSTemporaryDirectory();
                              let tmpPath = (tmpDirectory as NSString).appendingPathComponent(tmpFile);
                              if(FileManager.default.createFile(atPath: tmpPath, contents: imageData, attributes: [:])) {

                                  let fullNameArr = tmpPath.components(separatedBy: "/")

                                  let titleArr = fullNameArr.last!.components(separatedBy: ".")

                                  var imageItem  = [String:String]()

                                  imageItem = [
                                    "IMAGE_PATH" : tmpPath,
                                    "DISPLAY_NAME" : fullNameArr.last!,
                                    "TITLE" : titleArr.first!
                                  ]
                                  allImageInfoList.append(imageItem)
                              }
                          }
                          totalIteration += 1
                          if totalIteration == (fetchResult.count) {
                              result(allImageInfoList)
                          }
                      })
                  }
              },
              onAccessHasBeenDenied:{
                result(["Permissions Not Granted"])
              })
          }
  }

}

  public extension PHPhotoLibrary {

     static func execute(
                         onAccessHasBeenGranted: @escaping () -> Void,
                         onAccessHasBeenDenied: (() -> Void)? = nil) {

        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            print("Permissions Not Granted")
        }

        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
           onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
        case .denied, .restricted:
           onDeniedOrRestricted()
        case .authorized:
           onAccessHasBeenGranted()
        case .limited:
            onAccessHasBeenGranted()
        @unknown default:
           fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
     }

  }

  private func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {
     PHPhotoLibrary.requestAuthorization({ status in
        switch status {
        case .notDetermined:
           onNotDetermined(onDeniedOrRestricted, onAuthorized)
        case .denied, .restricted:
           onDeniedOrRestricted()
        case .authorized:
           onAuthorized()
        case .limited:
            onAuthorized()
        @unknown default:
           fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
     })
  }