import 'package:flutter/material.dart';

class MicSpeak extends StatelessWidget {
  const MicSpeak({
    Key? key,
    this.heightFactor,
    this.color = Colors.white,
    this.size = 84,
    this.activeColor = const Color.fromARGB(255, 35, 185, 1),
  }) : super(key: key);

  final Color? color;
  final Color? activeColor;
  final double? size;
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.mic,
            size: size,
            color: color,
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        child: Column(
          children: [
            ClipRRect(
              child: Align(
                alignment: Alignment.bottomLeft,
                heightFactor: heightFactor!,
                child: Icon(
                  Icons.mic,
                  size: size,
                  color: activeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
