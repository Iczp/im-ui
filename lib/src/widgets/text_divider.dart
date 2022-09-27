import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  ///
  const TextDivider(
    this.text, {
    super.key,
    this.widthFactor = 0.8,
    this.padding = const EdgeInsets.all(16),
    co,
    this.color = Colors.black38,
  });

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final String text;

  ///
  final double? widthFactor;

  ///
  final Color? color;

  ///
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Divider(
              color: color,
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
                child: Divider(
              color: color,
            )),
          ],
        ),
      ),
    );
  }
}
