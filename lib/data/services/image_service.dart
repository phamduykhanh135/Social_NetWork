import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:network/app/messages.dart';

class ImageService {
  Future<String> uploadImageUser(Uint8List imageBytes) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('image_user/${DateTime.now().millisecondsSinceEpoch}.jpeg');
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = storageRef.putData(imageBytes, metadata);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception(Messages.imageUploadError);
    }
  }

  Future<String> uploadImagePost(Uint8List imageBytes) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('image_post/${DateTime.now().millisecondsSinceEpoch}.jpeg');
      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = storageRef.putData(imageBytes, metadata);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw Exception(Messages.imageUploadError);
    }
  }
}
