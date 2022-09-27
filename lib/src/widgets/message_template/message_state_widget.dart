import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:im_core/im_core.dart';

/// 消息状态
class MessageStateWidget extends StatefulWidget {
  const MessageStateWidget({
    Key? key,
    required this.state,
    this.isDisplay = true,
    this.size = 32,
  }) : super(key: key);

  ///
  final MessageStateEnum state;

  ///
  final bool isDisplay;

  ///
  final double size;

  @override
  State<MessageStateWidget> createState() => MessageStateWidgetState();

  ///

}

class MessageStateWidgetState extends State<MessageStateWidget> {
  ///
  late MessageStateEnum _messageState;

  @override
  void initState() {
    _messageState = widget.state;
    super.initState();
  }

  ///
  void setMessageState(MessageStateEnum messageState) {
    setState(() {
      _messageState = messageState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDisplay || _messageState != MessageStateEnum.pending) {
      return const SizedBox();
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: const SpinKitHourGlass(
        // lineWidth: 0.5,
        color: Color.fromARGB(125, 139, 139, 139),
        size: 12.0,
      ),
    );
  }
}
