import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class ReminderMessageMenuButton extends MessageMenuButton {
  ///
  const ReminderMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '提醒';

  ///
  @override
  IconData get icon => Icons.notifications;

  @override
  State<ReminderMessageMenuButton> createState() =>
      _ReminderMessageMenuButtonState();
}

class _ReminderMessageMenuButtonState
    extends MessageMenuButtonState<ReminderMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();
  }
}
