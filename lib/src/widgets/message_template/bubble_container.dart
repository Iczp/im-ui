import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class BubbleContainer extends StatelessWidget {
  ///
  final BubbleEdges? padding;

  ///
  final bool isSelf;

  ///
  final Widget child;

  ///
  final bool isHover;

  ///
  final Color? color;

  ///
  const BubbleContainer({
    super.key,
    required this.isSelf,
    required this.child,
    this.isHover = false,
    this.padding = const BubbleEdges.all(10),
    this.color,
  });

  ///
  @override
  Widget build(BuildContext context) {
    return Bubble(
      elevation: isHover ? 1 : 0.5,
      padding: padding,
      margin: isSelf
          ? const BubbleEdges.only(right: 5)
          : const BubbleEdges.only(left: 5),
      // alignment: Alignment.topRight,
      nip: isSelf ? BubbleNip.rightTop : BubbleNip.leftTop,
      borderWidth: 0.3,
      // borderColor: const Color.fromARGB(125, 0, 0, 0),
      color: color ??
          (isSelf
              ? const Color.fromARGB(255, 109, 189, 255)
              : const Color.fromARGB(255, 255, 255, 255)),
      child: child,
    );
  }
}
