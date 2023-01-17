import 'package:flutter/material.dart';
import 'expand.dart';

class SessionLayout extends StatelessWidget {
  const SessionLayout({
    super.key,
    this.avatar,
    required this.title,
    this.side,
    required this.child,
    this.titleHeight = 24,
    this.padding = const EdgeInsets.all(8),
    this.separated = const SizedBox(width: 12),
    this.onTap,
    this.onLongPress,
    this.backgroupColor,
  });

  final Widget? avatar;

  final Widget title;

  final Widget? side;

  final Widget child;

  final double titleHeight;

  final EdgeInsetsGeometry? padding;

  final Widget separated;

  final void Function()? onTap;

  final void Function()? onLongPress;

  final Color? backgroupColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroupColor),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            // height: 56,
            padding: padding,
            child: Expand(
              fixed: avatar,
              separated: avatar == null ? Container() : separated,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: titleHeight,
                    child: Expand(
                      dir: TextDirection.rtl,
                      fixed: side,
                      separated: side == null ? Container() : separated,
                      child: title,
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
