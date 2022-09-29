import 'package:flutter/widgets.dart';
import 'package:im_core/im_core.dart';

import '../models/message_arguments.dart';
import 'templates/message_item_widget.dart';
import 'templates/file_message_widget.dart';
import 'templates/image_message_widget.dart';
import 'templates/sound_message_widget.dart';
import 'templates/text_message_widget.dart';
import 'templates/video_message_widget.dart';

///消息分解
class MessageResolver extends StatelessWidget {
  ///
  const MessageResolver({
    Key? key,
    required this.arguments,
    this.footer,
  }) : super(key: key);

  ///消息参数
  final MessageArguments arguments;

  ///
  final Widget? footer;

  ///
  MessageTypeEnum get messageType => arguments.message.type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildMessageItem(),
        footer ?? const SizedBox(),
      ],
    );
  }

  Widget buildMessageItem() {
    // Logger().d('${toString()}--build');
    switch (messageType) {
      case MessageTypeEnum.text:
        return TextMessageWidget(arguments: arguments);
      case MessageTypeEnum.sound:
        return SoundMessageWidget(arguments: arguments);
      case MessageTypeEnum.image:
        return ImageMessageWidget(arguments: arguments);
      case MessageTypeEnum.video:
        return VideoMessageWidget(arguments: arguments);
      case MessageTypeEnum.file:
        return FileMessageWidget(arguments: arguments);
      default:
        break;
    }
    return MessageItemWidget(arguments: arguments);
  }
}
