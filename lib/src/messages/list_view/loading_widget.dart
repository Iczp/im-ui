import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key? key,
    this.color,
    this.height = 48,
  }) : super(key: key);
  final double height;

  final Color? color;

  @override
  State<LoadingWidget> createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  bool _isVisible = false;

  double get height => widget.height;

  void show() {
    _isVisible = true;
    setState(() {});
  }

  void hide() {
    _isVisible = false;
    setState(() {});
  }

  void toggle() {
    _isVisible = !_isVisible;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox();
    }
    return SizedBox(
      height: height, //48+16
      child: SpinKitWave(
        color: widget.color,
        size: 14.0,
        itemCount: 5,
      ),
    );
  }
}
