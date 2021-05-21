import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image/image.dart' as im;

Future<List<Uint8List>> pickImage(BuildContext context) async {
  List<Uint8List> fromPicker =
      await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);
  return fromPicker;
}

Uint8List compressImage(Uint8List imageData) {
  final im.Image image = (im.Image.fromBytes(200, 200, imageData));
  return image.data.buffer.asUint8List();
}
