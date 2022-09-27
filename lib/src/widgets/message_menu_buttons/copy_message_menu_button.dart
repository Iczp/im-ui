import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import '../../app.dart';
import 'message_menu_button.dart';

class CopyMessageMenuButton extends MessageMenuButton {
  ///
  const CopyMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '复制';

  ///
  @override
  IconData get icon => Icons.copy;

  @override
  State<CopyMessageMenuButton> createState() => _CopyMessageMenuButtonState();
}

class _CopyMessageMenuButtonState
    extends MessageMenuButtonState<CopyMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.type}');
    super.onTap();
    if (message.type != MessageTypeEnum.text) {
      return;
    }
    var text = message.getContent<TextContentDto>().text;
    Logger().d('copy');
    Clipboard.setData(ClipboardData(text: text));
    showToast(msg: '复制成功');
  }
}
