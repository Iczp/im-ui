import 'package:flutter/material.dart';

///
abstract class InputButton extends StatefulWidget {
  ///
  final VoidCallback? onPressed;

  ///
  final double? size;

  ///
  const InputButton({
    Key? key,
    this.onPressed,
    this.size = 36,
  }) : super(key: key);

  ///
  IconData get icon;

  ///
  @override
  State<InputButton> createState() => InputButtonState();
}

///
class InputButtonState<T extends InputButton> extends State<InputButton> {
  ///
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 38,
    //   width: 38,
    //   child: Material(
    //     color: Colors.transparent,
    //     child: IconButton(
    //       onPressed: widget.onPressed,
    //       icon: Icon(widget.icon),
    //     ),
    //   ),
    // );
    return Container(
      height: widget.size,
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 3),
      child: IconButton(
        onPressed: widget.onPressed,
        icon: Icon(widget.icon),
      ),
    );
  }
}
