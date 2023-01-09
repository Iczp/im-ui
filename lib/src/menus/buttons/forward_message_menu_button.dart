import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class ForwardMessageMenuButton extends MessageMenuButton {
  ///
  const ForwardMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '转发';

  ///
  @override
  IconData get icon => Icons.forward;

  @override
  State<ForwardMessageMenuButton> createState() =>
      _ForwardMessageMenuButtonState();
}

class _ForwardMessageMenuButtonState
    extends MessageMenuButtonState<ForwardMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();
  }
}
