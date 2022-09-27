import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'function_button.dart';

class CameraFunctionButton extends FunctionButton {
  ///

  ///
  const CameraFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '拍照';

  ///
  @override
  IconData get icon => Icons.camera_alt;

  ///
  @override
  State<CameraFunctionButton> createState() => CameraFunctionButtonState();
}

class CameraFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('CameraFunctionButton');
    pickImageFromCamera();
    // Navigator.push(
    //     context,
    //     CupertinoPageRoute(
    //       builder: (context) => const CameraExampleHome(),
    //     ));
  }
}
