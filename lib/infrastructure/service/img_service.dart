import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImgService {
  ImgService._();

  static Future getGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  static Future getCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  static Future getFilePdf(ValueChanged<String> onChange) async {
    FilePickerResult? file;
    try {
      file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } catch (ex) {
      debugPrint('===> trying to select file $ex');
    }
    if (file?.paths.isNotEmpty ?? false) {
      onChange.call(file?.paths.first ?? '');
    }
  }
}
