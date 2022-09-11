import 'dart:io';
import 'package:all_gallery_images/model/StorageImages.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:all_gallery_images/all_gallery_images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StorageImages? _storageImages ;

  @override
  void initState() {
    super.initState();
    getImagesFromGallery();
  }

  Future<void> getImagesFromGallery() async {
    StorageImages? storageImages;
    try {
      storageImages = await GalleryImages().getStorageImages();
    } catch(error)
    {
      debugPrint(error.toString());
    }

    if (!mounted) return;

    setState(() {
      _storageImages = storageImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('All Gallery Images'),
        ),
        body: _storageImages!=null ?
        GridView.builder(
          itemCount: _storageImages!.images!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(File(_storageImages!.images![index].imagePath!)),
            );
          },
        )
            :const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
