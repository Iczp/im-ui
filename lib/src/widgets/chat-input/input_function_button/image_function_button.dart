import 'package:flutter/material.dart';
import 'function_button.dart';

class ImageFunctionButton extends FunctionButton {
  ///

  ///
  const ImageFunctionButton({super.key, super.onSend});

  ///
  @override
  String get text => '图片';

  ///
  @override
  IconData get icon => Icons.image_rounded;

  ///
  @override
  State<ImageFunctionButton> createState() => ImageFunctionButtonState();
}

class ImageFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  @override
  void onTap() {
    pickImageFromGallery();
  }
}
