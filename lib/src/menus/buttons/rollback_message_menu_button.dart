import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class RollbackMessageMenuButton extends MessageMenuButton {
  ///
  const RollbackMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '撤回';

  ///
  @override
  IconData get icon => Icons.u_turn_left_rounded;

  @override
  State<RollbackMessageMenuButton> createState() =>
      _RollbackMessageMenuButtonState();
}

class _RollbackMessageMenuButtonState
    extends MessageMenuButtonState<RollbackMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.type}');
    super.onTap();
  }
}
