import 'package:flutter/material.dart';

/// 发送按钮
class SendContainer extends StatefulWidget {
  const SendContainer(
      {Key? key,
      this.isDisplay = true,
      this.onPressed,
      this.isDisabled = false,
      this.child})
      : super(key: key);

  final bool isDisplay;
  final bool isDisabled;
  final VoidCallback? onPressed;
  final Widget? child;
  @override
  State<SendContainer> createState() => _SendContainerState();
}

class _SendContainerState extends State<SendContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 64,
      constraints: const BoxConstraints(
        maxWidth: 64,
      ),
      height: 32,
      margin: const EdgeInsets.only(bottom: 5),
      child: widget.child ??
          ElevatedButton(
            onPressed: widget.onPressed,
            child: const Text(
              'send',
              style: TextStyle(fontSize: 14),
            ),
          ),
    );
  }
}
