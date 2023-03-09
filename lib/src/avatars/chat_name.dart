import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers.dart';

class ChatName extends StatelessWidget {
  const ChatName({
    Key? key,
    this.id,
    this.color,
    this.size = 14,
    this.margin,
    this.padding,
    this.fontWeight,
  }) : super(key: key);

  ///
  final int? id;

  final Color? color;

  final double size;

  final FontWeight? fontWeight;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Selector<ChatObjectProvider, String>(
      selector: ((_, x) => id != null ? x.getName(id!) : ''),
      builder: (_, value, child) {
        return Container(
          padding: padding,
          margin: margin,
          child: Text(
            '$value-1',
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
          ),
        );
      },
    );
  }
}
