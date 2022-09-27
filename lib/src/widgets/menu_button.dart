import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

typedef MenuItemTapCallback = void Function(MenuButton);

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    this.direction = Axis.horizontal,
    required this.iconData,
    required this.text,
    this.onTap,
    required this.code,
    this.disabled = false,
    this.width,
    this.height,
    this.color,
    this.iconSize = 18,
    this.textSize = 14,
  }) : super(key: key);

  ///
  final Axis direction;

  ///
  final IconData iconData;

  ///
  final String text;

  ///
  final MenuTypeEnum code;

  ///
  final MenuItemTapCallback? onTap;

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
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: InkWell(
        // borderRadius: BorderRadius.circular(4),
        // splashColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: () => onTap?.call(this),
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
