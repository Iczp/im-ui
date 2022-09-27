import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import '../../commons/utils.dart';
import '../../models/message_arguments.dart';
import '../../widgets/message_template/message_widget.dart';

class MessageTemplateWidget<TMessage extends MessageDto>
    extends MessageWidget<TMessage> {
  MessageTemplateWidget({
    Key? key,
    required super.arguments,
  }) : super(key: key);

  // static const double marginAll = 8;

  @override
  GestureTapCallback? get onMessageTap => (() {
        Utils.vibrateIfSuccess(super.onMessageTap);
      });

  @override
  GlobalKeyCallback? get onMessageLongPress => ((_) {
        Utils.vibrateIfSuccess(() {
          super.onMessageLongPress!(_);
        });
      });

  ///
  @override
  State<MessageTemplateWidget> createState() => MessageItemWidgetState();
}

///
class MessageItemWidgetState<T>
    extends MessageWidgetState<MessageTemplateWidget> {}
