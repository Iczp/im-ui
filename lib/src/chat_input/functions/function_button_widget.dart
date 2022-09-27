import 'package:flutter/material.dart';

class FunctionButtonWidget extends StatelessWidget {
  ///
  final Axis direction;

  ///
  final IconData iconData;

  ///
  final String text;

  ///
  final bool disabled;

  ///
  final double? width;

  ///
  final double? height;

  ///
  final Color? color;

  ///
  final double? iconSize;

  ///
  final double? textSize;

  ///
  final GestureTapCallback? onTap;

  ///
  const FunctionButtonWidget({
    Key? key,
    this.direction = Axis.horizontal,
    required this.iconData,
    required this.text,
    this.disabled = false,
    this.width,
    this.height,
    this.color,
    this.iconSize = 36,
    this.textSize = 14,
    this.onTap,
  }) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // splashColor: Colors.black12,
          // highlightColor: Colors.red,
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          // onLongPress: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Flex(
              direction: direction,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    iconData,
                    color: color,
                    size: iconSize,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  // height: 24,
                  // color: Colors.red,
                  child: Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: textSize,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
