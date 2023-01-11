import 'package:flutter/material.dart';

class ImmersedIcon extends StatelessWidget {
  const ImmersedIcon({
    super.key,
    this.size = 14,
    this.color = Colors.black26,
    this.visible = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  });

  final double size;

  final Color? color;

  final bool visible;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Container();
    }
    return Container(
      padding: padding,
      child: Icon(
        Icons.notifications_off,
        size: size,
        color: color,
      ),
    );
  }
}
