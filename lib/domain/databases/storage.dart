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

  Future<String> uploadQuestionImages(
    String imageName,
    FilePickerResult? imageFile,
    WidgetRef ref,
  ) async {
    Uint8List fileBytes = imageFile!.files.first.bytes ?? Uint8List(0);
    final questionImagesRef = storageRef.child("question/$imageName");
    await questionImagesRef.putData(
      fileBytes,
      SettableMetadata(contentType: 'image'),
    );
    var url = await questionImagesRef.getDownloadURL();
    return url;
  }

  Future deleteQuestionImage(String imageName) async {
    final questionImagesRef = storageRef.child("question/$imageName");

    // trying to get the download url of the question image
    // if the download url doesn't exist then we will get an error indicating that the image doesn't exist
    try {
      await questionImagesRef.getDownloadURL();
    } catch (e) {
      return; // if the image does not exist, we just return
    }

    await questionImagesRef.delete();
  }

  Future deleteImage(String imageName) async {
    final questionImagesRef = storageRef.child("images/$imageName");

    // trying to get the download url of the question image
    // if the download url doesn't exist then we will get an error indicating that the image doesn't exist
    try {
      await questionImagesRef.getDownloadURL();
    } catch (e) {
      return; // if the image does not exist, we just return
    }

    await questionImagesRef.delete();
  }
}
