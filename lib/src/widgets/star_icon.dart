import 'package:flutter/material.dart';

class StarIcon extends StatelessWidget {
  const StarIcon({
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
    // Logger().d(visible);
    if (!visible) {
      return Container();
    }
    return Container(
      padding: padding,
      child: Icon(
        Icons.star,
        size: size,
        color: color,
      ),
    );
  }
}
