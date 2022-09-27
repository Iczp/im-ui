import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';
import 'message_menu_button.dart';
import '../../chat_input/chat_input.dart';

class QuoteMessageMenuButton extends MessageMenuButton {
  ///
  const QuoteMessageMenuButton(super.arguments, {super.key});

  ///
  @override
  String get text => '引用';

  ///
  @override
  IconData get icon => Icons.format_quote_sharp;

  @override
  State<QuoteMessageMenuButton> createState() => _QuoteMessageMenuButtonState();
}

class _QuoteMessageMenuButtonState
    extends MessageMenuButtonState<QuoteMessageMenuButton> {
  ///
  @override
  void onTap() {
    Logger().i('${toString()} - ${message.type}');
    super.onTap();
    widget.arguments.chatInputKey
        ?.state<ChatInputState>()
        ?.setQuoteMessage(message);
  }
}
