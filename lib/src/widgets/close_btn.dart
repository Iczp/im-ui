import 'package:flutter/material.dart';

///关闭按钮
class CloseBtn extends StatefulWidget {
  const CloseBtn({
    Key? key,
    this.onClose,
    this.size = 18,
    this.backgroundColor = const Color.fromARGB(255, 139, 20, 20),
    this.isDisplayClose = true,
  }) : super(key: key);

  final VoidCallback? onClose;
  final double size;
  final Color? backgroundColor;

  ///
  final bool isDisplayClose;
  @override
  State<CloseBtn> createState() => _CloseBtnState();
}

class _CloseBtnState extends State<CloseBtn> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isDisplayClose) {
      return const SizedBox();
    }
    return InkWell(
      onTap: widget.onClose,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircleAvatar(
          // radius: 14,
          backgroundColor: widget.backgroundColor,
          child: const Icon(
            Icons.clear_rounded,
            size: 16,
          ),
        ),
      ),
    );
  }
}
