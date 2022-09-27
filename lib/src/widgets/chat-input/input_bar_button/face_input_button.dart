import 'package:flutter/material.dart';

import 'input_button.dart';

class FaceInputButton extends InputButton {
  ///
  const FaceInputButton({
    Key? key,
    super.onPressed,
  }) : super(key: key);

  ///
  @override
  IconData get icon => Icons.face_retouching_natural_sharp;

  ///
  @override
  InputButtonState<FaceInputButton> createState() => _FaceInputButtonState();
}

class _FaceInputButtonState extends InputButtonState<FaceInputButton> {}
