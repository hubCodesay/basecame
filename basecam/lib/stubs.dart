// Minimal stubs to satisfy analyzer in environments where the real packages
// are not installed. These are only for compilation during development and
// should be replaced by actual packages in production.

import 'dart:typed_data';

class ImageSource {
  static const gallery = ImageSource._('gallery');
  static const camera = ImageSource._('camera');
  final String name;
  const ImageSource._(this.name);
}

class XFile {
  final String path;
  XFile(this.path);
  Future<Uint8List> readAsBytes() async => Uint8List(0);
}

class ImagePicker {
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async => null;
}

class SettableMetadata {
  final String? contentType;
  SettableMetadata({this.contentType});
}

class TaskSnapshot {
  final int bytesTransferred;
  final int totalBytes;
  TaskSnapshot({this.bytesTransferred = 0, this.totalBytes = 1});
}

class UploadTask {
  // simple stream that never emits in stub
  Stream<TaskSnapshot> get snapshotEvents => const Stream.empty();
  Future<void> whenComplete(void Function() action) async => action();
}

class Reference {
  Reference child(String path) => this;
  UploadTask putData(Uint8List data, [SettableMetadata? metadata]) =>
      UploadTask();
  UploadTask putFile(dynamic file, [SettableMetadata? metadata]) =>
      UploadTask();
  Future<String> getDownloadURL() async => '';
  Future<void> delete() async {}
}

class FirebaseAppOptionsStub {
  final String storageBucket;
  FirebaseAppOptionsStub({this.storageBucket = ''});
}

class FirebaseAppStub {
  final FirebaseAppOptionsStub options = FirebaseAppOptionsStub();
}

class FirebaseStorage {
  FirebaseStorage._();
  static FirebaseStorage get instance => FirebaseStorage._();
  FirebaseAppStub get app => FirebaseAppStub();
  Reference ref() => Reference();
  Reference refFromURL(String url) => Reference();
}

// Minimal GeoPoint stub used in map.dart
class GeoPoint {
  final double latitude;
  final double longitude;
  GeoPoint(this.latitude, this.longitude);
}
