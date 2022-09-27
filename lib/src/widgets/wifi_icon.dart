import 'package:flutter/material.dart';

class WifiIcon extends StatefulWidget {
  const WifiIcon({
    Key? key,
    this.isPlay = false,
    this.isSelf = false,
    this.size,
    this.color,
  }) : super(key: key);

  /// 是否播放
  final bool isPlay;

  ///
  final bool isSelf;

  ///
  final double? size;

  final Color? color;

  ///
  @override
  State<WifiIcon> createState() => _WifiIconState();
}

class _WifiIconState extends State<WifiIcon> with TickerProviderStateMixin {
  ///
  late final _icons = [
    Icon(
      Icons.wifi_rounded,
      size: widget.size,
      color: widget.color,
    ),
    Icon(
      Icons.wifi_2_bar_rounded,
      size: widget.size,
      color: widget.color,
    ),
    Icon(
      Icons.wifi_1_bar_rounded,
      size: widget.size,
      color: widget.color,
    ),
    Icon(
      Icons.wifi_2_bar_rounded,
      size: widget.size,
      color: widget.color,
    ),
    Icon(
      Icons.wifi_rounded,
      size: widget.size,
      color: widget.color,
    ),
  ];

  ///
  late final AnimationController _controller = AnimationController(
    animationBehavior: AnimationBehavior.preserve,
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  ///
  late final Animation<int> _tween =
      IntTween(begin: _icons.length - 1, end: 0).animate(_controller);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var quarterTurns = widget.isSelf ? -1 : 1;

    if (!widget.isPlay) {
      _controller.stop();
      _controller.reset();
    } else {
      _controller.repeat();
    }
    return AnimatedBuilder(
      animation: _tween,
      builder: (BuildContext context, Widget? child) {
        return RotatedBox(
          // angle: -90 * pi / 180,
          quarterTurns: quarterTurns,
          child: _icons[_tween.value],
        );
      },
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: _icons[_icons.length - 1],
      ),
    );
  }
}
