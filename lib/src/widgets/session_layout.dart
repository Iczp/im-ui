import 'package:flutter/material.dart';
import 'expand.dart';

class SessionLayout extends StatelessWidget {
  const SessionLayout({
    super.key,
    this.avatar,
    required this.title,
    this.subTitle,
    required this.child,
    this.titleHeight = 24,
    this.padding = const EdgeInsets.all(8),
    this.separated = const SizedBox(width: 8),
    this.onTap,
  });

  final Widget? avatar;

  final Widget title;

  final Widget? subTitle;

  final Widget child;

  final double titleHeight;

  final EdgeInsetsGeometry? padding;

  final Widget separated;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                  fixed: subTitle,
                  separated: subTitle == null ? Container() : separated,
                  child: title,
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
