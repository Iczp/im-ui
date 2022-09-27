import 'package:flutter/material.dart';

class MicLine extends StatelessWidget {
  const MicLine({
    Key? key,
    this.heightFactor,
    this.right,
    this.left,
    this.backgroupColor = const Color.fromARGB(255, 35, 185, 1),
  }) : super(key: key);

  final double? heightFactor;
  final double? right;
  final double? left;
  final Color backgroupColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: 10,
      bottom: 10,
      child: ClipRect(
        child: FractionallySizedBox(
          // heightFactor: 1.5, // heightFactor,
          heightFactor: heightFactor,
          child: Container(
            decoration: BoxDecoration(
                // color: Color.fromARGB(97, 253, 1, 1),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: backgroupColor,
                    blurRadius: 0.5,
                  )
                ]),
            child: const SizedBox(
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
