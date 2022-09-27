import 'package:flutter/material.dart';

class MicRollback extends StatelessWidget {
  const MicRollback({
    Key? key,
    this.color = const Color.fromARGB(255, 185, 41, 1),
    this.size = 84,
  }) : super(key: key);

  ///color
  final Color? color;

  ///size
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.u_turn_left_outlined,
      color: color,
      size: size,
    );
  }
}
