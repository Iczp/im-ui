import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key? key,
    this.onPressed,
    this.iconData,
    this.size = 36.0,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final IconData? iconData;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(
        // top: 5,
        bottom: 5,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: IconButton(
          // key: ValueKey<IconData>(iconData!),
          // key: ValueKey<int>(3),
          onPressed: onPressed,
          icon: Icon(iconData),
        ),
      ),
    );
  }
}
