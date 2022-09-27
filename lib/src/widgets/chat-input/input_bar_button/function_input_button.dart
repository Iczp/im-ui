import 'package:flutter/material.dart';

import 'input_button.dart';

///
class FunctionInputButton extends InputButton {
  ///
  const FunctionInputButton({
    Key? key,
    super.onPressed,
  }) : super(key: key);

  ///
  @override
  IconData get icon => Icons.add;

  ///
  @override
  InputButtonState<FunctionInputButton> createState() =>
      _FunctionInputButtonState();
}

///
class _FunctionInputButtonState extends InputButtonState<FunctionInputButton> {}
