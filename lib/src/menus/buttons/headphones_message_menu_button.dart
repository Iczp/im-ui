import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class HeadphonesMessageMenuButton extends MessageMenuButton {
  ///
  const HeadphonesMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '听筒';

  ///
  @override
  IconData get icon => Icons.headphones;

  @override
  State<HeadphonesMessageMenuButton> createState() =>
      _HeadphonesMessageMenuButton();
}

class _HeadphonesMessageMenuButton
    extends MessageMenuButtonState<HeadphonesMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();
  }
}
