import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UploaderService {
  Future<String> uploadFile(
      String imageFileName, Uint8List imageToUpload) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child(imageFileName);
    UploadTask uploadTask = ref.putData(imageToUpload);

    final taskSnapshot = await Future.value(uploadTask);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadQuotationImage(
    Uint8List imageToUpload,
  ) async {
    final id = Uuid().v1();
    var imageFileName = 'quotations/$id.png';
    return await uploadFile(imageFileName, imageToUpload);
  }
}
