import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import '../../../models/message_arguments.dart';

import '../../message_menu_buttons_all.dart';
import '../bubble_container.dart';
import '../message_template_widget.dart';
import '../message_widget.dart';

class TextMessageWidget extends MessageTemplateWidget {
  TextMessageWidget({
    Key? key,
    required super.arguments,
  }) : super(key: key);

  ///文本
  TextContentDto get content => arguments.message.getContent<TextContentDto>();

  @override
  State<TextMessageWidget> createState() => _TextMessageWidgetState();
}

class _TextMessageWidgetState extends MessageWidgetState<TextMessageWidget> {
  ///
  TextDirection get textDirection =>
      widget.isSelf ? TextDirection.rtl : TextDirection.ltr;

  ///
  @override
  Widget buildMessageContentWidget(BuildContext context) {
    // return Text('data');
    return bodyGestureDetector(
      child: BubbleContainer(
        isSelf: widget.isSelf,
        child: RichText(
          text: TextSpan(
            text: widget.content.text,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 47, 47, 47),
              // overflow: TextOverflow.ellipsis,
              overflow: TextOverflow.visible,
              // color: widget.isSelf
              //     ? const Color.fromARGB(255, 247, 255, 248)
              //     : const Color.fromARGB(255, 47, 47, 47),
            ),
          ),
        ),
      ),
    );
  }

  ///
  @override
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments) => [
        CopyMessageMenuButton(arguments),
        QuoteMessageMenuButton(arguments),
        // SoundPlayMessageMenuButton(arguments),
        // ForwardMessageMenuButton(arguments),
        FavoriteMessageMenuButton(arguments),
        ReminderMessageMenuButton(arguments),
        HeadphonesMessageMenuButton(arguments),
        ChoiceMessageMenuButton(arguments),
        RollbackMessageMenuButton(arguments),
      ];
}
