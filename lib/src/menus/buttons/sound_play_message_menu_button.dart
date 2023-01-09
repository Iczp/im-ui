import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class SoundPlayMessageMenuButton extends MessageMenuButton {
  ///
  const SoundPlayMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '播放';

  ///
  @override
  IconData get icon => Icons.play_circle_fill_sharp;

  @override
  State<SoundPlayMessageMenuButton> createState() =>
      _SoundPlayMessageMenuButtonState();
}

class _SoundPlayMessageMenuButtonState
    extends MessageMenuButtonState<SoundPlayMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();
  }
}
