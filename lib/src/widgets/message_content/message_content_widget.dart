import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import '../../models/message_arguments.dart';

///消息内容部件
abstract class MessageContentWidget<TContent> extends StatefulWidget {
  const MessageContentWidget({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  ///
  final MessageArguments arguments;

  MessageDto get message => arguments.message;

  TContent get content => message.getContent<TContent>();

  ///最小高度
  final double minContentHeight = 48;

  ///
  bool get isSelf => arguments.message.isSelf();

  // final Widget copyMenuItem = MediaMenuItem(
  //   direction: Axis.vertical,
  //   iconData: Icons.forward,
  //   text: '转发',
  //   code: MenuTypeEnum.forward,
  //   onTap: (_) {
  //     if (arguments.message.messageType == MessageTypeEnum.text) {}
  //   },
  // );

  ///气泡容器
  Widget bubbleContainer({
    Widget? child,
  }) {
    return Bubble(
      padding: const BubbleEdges.all(10),
      margin: isSelf
          ? const BubbleEdges.only(right: 5)
          : const BubbleEdges.only(left: 5),
      alignment: Alignment.topRight,
      nip: isSelf ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: isSelf
          ? Colors.blue.shade400
          : const Color.fromARGB(255, 255, 255, 255),
      child: Container(
        // padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(
          maxWidth: 240, //宽度尽可能大
          // minWidth: widget.minContentHeight / 2,
          // minHeight: 24.0 //最小高度为50像素
        ),
        child: child,
      ),
    );
  }

  // @override
  // State<MessageContentWidget> createState() => _BaseMessageContentWidgetState();
}

// class _BaseMessageContentWidgetState extends State<MessageContentWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // widget.onMessageLongPress1()
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: const BoxDecoration(
//         gradient: RadialGradient(
//           //背景径向渐变
//           colors: [
//             Color.fromARGB(255, 21, 221, 81),
//             Color.fromARGB(255, 17, 208, 65)
//           ],
//           center: Alignment.topLeft,
//           radius: .98,
//         ),
//       ),
//       child: const Text(
//         "ddd",
//         style: TextStyle(
//           color: Colors.red,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }
