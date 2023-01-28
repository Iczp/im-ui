import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers.dart';

class ChatName extends StatelessWidget {
  const ChatName({
    Key? key,
    this.id,
    this.color = Colors.black87,
    this.fontSize = 14,
  }) : super(key: key);

  ///
  final String? id;

  final Color color;

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Selector<ChatObjectProvider, String>(
      selector: ((_, x) => id != null ? x.getName(id!) : ''),
      builder: (_, value, child) {
        return Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}
