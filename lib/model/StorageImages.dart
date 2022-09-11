class StorageImages {
  List<Images>? images;

  StorageImages({this.images,});

  StorageImages.fromJson(dynamic json) {
    if (json!= null) {
      images = [];
      json.forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
  }
}

class Images {
  String? imagePath;
  String? displayName;
  String? title;

  Images({
      this.imagePath,
      this.displayName,
      this.title,});

  Images.fromJson(dynamic json) {
    imagePath = json['IMAGE_PATH'];
    displayName = json['DISPLAY_NAME'];
    title = json['TITLE'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IMAGE_PATH'] = imagePath;
    map['DISPLAY_NAME'] = displayName;
    map['TITLE'] = title;
    return map;
  }
}