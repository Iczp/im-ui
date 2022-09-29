import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import '../message_widget.dart';

class MessageTemplateWidget<TMessage extends MessageDto>
    extends MessageWidget<TMessage> {
  const MessageTemplateWidget({
    super.key,
    required super.arguments,
  });

  // static const double marginAll = 8;

  // @override
  // GestureTapCallback? get onMessageTap => (() {
  //       Utils.vibrateIfSuccess(super.onMessageTap);
  //     });

  // @override
  // VoidCallback? get onMessageLongPress => (() {
  //       Utils.vibrateIfSuccess(() {
  //         super.onMessageLongPress!();
  //       });
  //     });

  ///
  @override
  State<MessageTemplateWidget> createState() => MessageItemWidgetState();
}

///
class MessageItemWidgetState<T>
    extends MessageWidgetState<MessageTemplateWidget> {}
