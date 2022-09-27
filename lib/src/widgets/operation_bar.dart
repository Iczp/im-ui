import 'package:flutter/material.dart';

///
class OperationBar extends StatefulWidget {
  const OperationBar({
    Key? key,
    this.height = 56,
    required this.child,
  }) : super(key: key);

  ///
  final double? height;

  ///
  final Widget child;

  ///
  @override
  State<OperationBar> createState() => _OperationBarState();
}

class _OperationBarState extends State<OperationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Divider(
            color: Colors.grey.shade500,
            height: 0.5,
          ),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
