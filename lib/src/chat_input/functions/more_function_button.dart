import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'function_button.dart';

class MoreFunctionButton extends FunctionButton {
  ///

  ///
  const MoreFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '...';

  ///
  @override
  IconData get icon => Icons.more;

  ///
  @override
  State<MoreFunctionButton> createState() => MoreFunctionButtonState();
}

class MoreFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  @override
  void onTap() {
    Logger().d('MoreFunctionButton');
  }
}
