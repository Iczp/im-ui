import 'package:im_core/im_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../models/message_arguments.dart';
import '../message_menu_button_widget.dart';

class MessageMenuButton extends StatefulWidget {
  ///
  const MessageMenuButton(
    this.arguments, {
    super.key,
  });

  ///
  final MessageArguments arguments;

  ///
  String get text => '';

  ///
  IconData get icon => Icons.copy;

  ///
  List<MediaTypeEnum> get mediaTypes => [];

  ///
  List<MessageTypeEnum> get messageTypes => [];

  ///
  @override
  State<MessageMenuButton> createState() => MessageMenuButtonState();
}

class MessageMenuButtonState<T extends MessageMenuButton> extends State<T> {
  ///
  MessageDto get message => widget.arguments.message;

  ///
  void onTap() {
    Logger().d('supper MessageMenuButtonState');
    widget.arguments.messageDialogKey?.currentState?.close();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return MessageMenuButtonWidget(
      direction: Axis.vertical,
      color: Colors.white70,
      iconData: widget.icon,
      text: widget.text,
      disabled: false,
      width: 40,
      onTap: onTap,
    );
  }
}
