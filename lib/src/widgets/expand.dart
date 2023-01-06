import 'package:flutter/cupertino.dart';

class Expand extends StatefulWidget {
  const Expand({
    super.key,
    this.fixed,
    this.separated,
    required this.child,
    this.axis = Axis.horizontal,
    this.dir = TextDirection.ltr,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final Widget? fixed;

  final Widget child;

  final Widget? separated;

  final Axis axis;

  final TextDirection dir;

  /// How the children should be placed along the main axis.
  ///
  /// For example, [MainAxisAlignment.start], the default, places the children
  /// at the start (i.e., the left for a [Row] or the top for a [Column]) of the
  /// main axis.
  final MainAxisAlignment mainAxisAlignment;

  @override
  State<Expand> createState() => _ExpandState();
}

class _ExpandState extends State<Expand> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: widget.mainAxisAlignment,
      direction: widget.axis,
      textDirection: widget.dir,
      children: [
        widget.fixed ?? Container(),
        widget.separated ?? Container(),
        Expanded(child: widget.child),
      ],
    );
  }
}
