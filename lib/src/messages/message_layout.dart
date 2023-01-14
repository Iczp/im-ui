import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  const MessageLayout({
    super.key,
    this.header,
    this.footer,
    required this.child,
  });

  final Widget? header;

  final Widget? footer;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
