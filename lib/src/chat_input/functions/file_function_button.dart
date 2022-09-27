import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';

import 'function_button.dart';

class FileFunctionButton extends FunctionButton {
  ///

  ///
  const FileFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '文件';

  ///
  @override
  IconData get icon => Icons.folder_rounded;

  ///
  @override
  State<FileFunctionButton> createState() => FileFunctionButtonState();
}

class FileFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  Future<void> onTap() async {
    Logger().d('FileFunctionButton');

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) {
      throw FlutterError('FilePicker result is null');
    }

    Logger().d(result.files);

    Logger().d('path:${result.files.single.path}');

    File file = File(result.files.single.path!);

    // Share.shareFiles([file.path], text: 'Great picture');

    Logger().d('file.path:${file.path}');

    Logger().d('path:${file.path}');

    Logger().d('length:${await file.length()}');

    /// contentType
    final mimeType = lookupMimeType(file.path);

    ///
    var fileContent = FileContentDto(
      path: file.absolute.path,
      fileName: p.basename(file.path),
      contentType: mimeType,
      contentLength: await file.length(),
      suffix: p.extension(file.path, 1),
    );

    Logger().d(fileContent.toJson());

    widget.onSend?.call(fileContent);
  }
}
