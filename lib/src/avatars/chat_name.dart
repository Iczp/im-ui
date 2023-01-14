import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers.dart';

class ChatName extends StatelessWidget {
  const ChatName({
    Key? key,
    this.id,
  }) : super(key: key);

  ///
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Selector<ChatObjectProvider, String>(
      selector: ((_, x) => id != null ? x.getName(id!) : ''),
      builder: (_, value, child) {
        return Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        );
      },
    );
  }
}
