import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Mask extends StatefulWidget {
  const Mask({
    Key? key,
    this.caller,
    this.color,
    this.onClose,
    this.child,
  }) : super(key: key);

  ///
  final GestureTapCallback? onClose;

  /// 为null 则不显示
  final String? caller;

  ///
  final Color? color;

  ///
  final Widget? child;

  @override
  State<Mask> createState() => MaskState();
}

///
class MaskState extends State<Mask> {
  ///
  String? _caller;

  @override
  initState() {
    _caller = widget.caller;
    super.initState();
  }

  ///
  GlobalKey<State<Mask>>? getGlobalKey() =>
      widget.key as GlobalKey<State<Mask>>;

  ///
  void show(String caller) {
    Logger().d('$toString() - show');
    setState(() {
      _caller = caller;
    });
  }

  ///
  void close() {
    Logger().d('mask close');
    setState(() {
      _caller = null;
      widget.onClose?.call();
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (_caller == null) {
      return const SizedBox();
    }
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: close,
          child: Container(
            color: widget.color,
            child: Stack(
              children: [widget.child ?? const SizedBox()],
            ),
          ),
        ),
      ),
    );
  }
  // ///
  // @override
  // Widget build(BuildContext context) {
  //   if (_caller == null) {
  //     return const SizedBox();
  //   }
  //   return Positioned(
  //     left: 0,
  //     right: 0,
  //     top: 0,
  //     bottom: 0,
  //     child: Material(
  //       color: Colors.transparent,
  //       child: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           Positioned(
  //             left: 0,
  //             right: 0,
  //             top: 0,
  //             bottom: 0,
  //             child: InkWell(
  //               onTap: close,
  //               child: Container(
  //                 color: widget.color,
  //               ),
  //             ),
  //           ),
  //           widget.child ?? const SizedBox()
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
