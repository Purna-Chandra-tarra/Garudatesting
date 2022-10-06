import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  final storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImages(
    String imageName,
    FilePickerResult? imageFile,
    WidgetRef ref,
  ) async {
    Uint8List fileBytes = imageFile!.files.first.bytes ?? Uint8List(0);
    final questionImagesRef = storageRef.child("images/$imageName");
    await questionImagesRef.putData(
      fileBytes,
      SettableMetadata(contentType: 'image'),
    );
    var url = await questionImagesRef.getDownloadURL();
    return url;
  }

  Future deleteImage(String imageName) async {
    final questionImagesRef = storageRef.child("images/$imageName");
    await questionImagesRef.delete();
  }
}
