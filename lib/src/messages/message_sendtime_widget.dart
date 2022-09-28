import 'package:flutter/material.dart';
import '../commons/utils.dart';

/// 消息发送时间
class MessageSendtimeWidget extends StatelessWidget {
  const MessageSendtimeWidget({
    Key? key,
    required this.sendTime,
    this.isDisplay = true,
  }) : super(key: key);

  ///
  final bool isDisplay;

  ///
  final DateTime sendTime;

  String get sendTimeDisplay => formatTime(sendTime);

  @override
  Widget build(BuildContext context) {
    if (!isDisplay) {
      return const SizedBox();
    }
    return Center(
      child: Container(
        // height: 22,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),

        child: Text(
          sendTimeDisplay,
          style: const TextStyle(
            color: Colors.black26,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
