import 'package:flutter/material.dart';

import 'input_button.dart';

class ModeInputButton extends InputButton {
  ///
  const ModeInputButton({
    Key? key,
    super.onPressed,
  }) : super(key: key);

  ///
  @override
  IconData get icon => Icons.face;

  ///
  @override
  InputButtonState<ModeInputButton> createState() => _ModeInputButtonState();
}

class _ModeInputButtonState extends InputButtonState<ModeInputButton> {}
