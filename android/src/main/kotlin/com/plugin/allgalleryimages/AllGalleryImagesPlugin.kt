package com.plugin.allgalleryimages

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** AllGalleryImagesPlugin */
class AllGalleryImagesPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.RequestPermissionsResultListener{

  private lateinit var channel : MethodChannel
  private lateinit var result: Result
  private lateinit var activity: Activity
  private var allImageInfoList = ArrayList<HashMap<String,String>>()
  companion object {
    private const val PERMISSION_REQUEST_CODE = 101
    private const val CHANNEL_NAME = "plugins.io/all_gallery_images"
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getAllImagesFromStorage") {
      this.result = result
      getPermissionResult(result,activity)
    } else {
      result.notImplemented()
    }
  }

  private fun getPermissionResult(result: Result, activity: Activity) {
    if (Build.VERSION.SDK_INT >= 23) {
      if (ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
        result.success(getAllImageList(activity))
      }
      else{
        ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), PERMISSION_REQUEST_CODE)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onRequestPermissionsResult(requestCode: Int,
                                          permissions: Array<String>,
                                          grantResults: IntArray): Boolean {
    if (requestCode == PERMISSION_REQUEST_CODE) {
      if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        result.success(getAllImageList(activity))
        return true
      }
      if (grantResults.isNotEmpty() && grantResults[0] ==  PackageManager.PERMISSION_DENIED) {
        result.success(listOf("Permissions Not Granted"))
      }
    }
    return false
  }

  private fun getAllImageList(activity: Activity): ArrayList<HashMap<String, String>> {

    val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
    val projection = arrayOf(
      MediaStore.Images.ImageColumns.DATA,
      MediaStore.Images.ImageColumns.DISPLAY_NAME,
      MediaStore.Images.ImageColumns.TITLE,
    )
    val c = activity.contentResolver.query(uri, projection, null, null, null)
    if (c != null) {
      Log.e("",c.count.toString())
    }
    if (c != null) {
      while (c.moveToNext()) {
        val params = HashMap<String, String>()
        params["IMAGE_PATH"] = c.getString(0)
        params["DISPLAY_NAME"] = c.getString(1)
        params["TITLE"] = c.getString(2)
        allImageInfoList.add(params)
      }
      c.close()
    }
    return allImageInfoList
  }
}
