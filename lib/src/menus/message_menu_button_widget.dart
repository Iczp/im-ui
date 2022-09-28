import 'package:flutter/material.dart';

class MessageMenuButtonWidget extends StatelessWidget {
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
  const MessageMenuButtonWidget({
    Key? key,
    this.direction = Axis.horizontal,
    required this.iconData,
    required this.text,
    this.disabled = false,
    this.width,
    this.height,
    this.color,
    this.iconSize = 18,
    this.textSize = 14,
    this.onTap,
  }) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
        // borderRadius: BorderRadius.circular(4),
        // splashColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(5),
          child: Flex(
            direction: direction,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: color,
                size: iconSize,
              ),
              SizedBox(
                height: 20,
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
    );
  }
}
