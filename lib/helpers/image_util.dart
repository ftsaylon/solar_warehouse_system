import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

Future<List<Uint8List>> pickImage(BuildContext context) async {
  List<Uint8List> fromPicker =
      await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes);
  return fromPicker;
}
