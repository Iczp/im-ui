import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';

class FavoriteMessageMenuButton extends MessageMenuButton {
  ///
  const FavoriteMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '收藏';

  ///
  @override
  IconData get icon => Icons.bookmark_add;

  @override
  State<FavoriteMessageMenuButton> createState() =>
      _FavoriteMessageMenuButtonState();
}

class _FavoriteMessageMenuButtonState
    extends MessageMenuButtonState<FavoriteMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.messageType}');
    super.onTap();
  }
}
