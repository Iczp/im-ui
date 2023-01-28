import 'dart:async';

import 'package:flutter/material.dart';

import '../../commons.dart';

class RealDatetime extends StatefulWidget {
  const RealDatetime({
    super.key,
    this.dateTime,
    this.duration = const Duration(seconds: 1),
    this.fontSize = 12,
    this.color = Colors.black54,
  });

  final DateTime? dateTime;

  final Duration duration;

  final double fontSize;

  final Color color;
  @override
  State<RealDatetime> createState() => _RealDatetimeState();
}

class _RealDatetimeState extends State<RealDatetime> {
  late DateTime? datetime = widget.dateTime;

  late String displayDatetime = datetime != null ? formatTime(datetime!) : '';

  late Timer? _timer;

  ///
  @override
  void initState() {
    super.initState();
    _timer = null;
    if (datetime != null && DateTime.now().difference(datetime!).inDays < 1) {
      _timer = Timer.periodic(widget.duration, (timer) {
        if (datetime != null) {
          var oldValue = displayDatetime;
          displayDatetime = formatTime(datetime!);
          if (oldValue != displayDatetime) {
            setState(() {});
          }
        }
      });
    }
  }

  ///
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  ///

  @override
  Widget build(BuildContext context) {
    return Text(
      displayDatetime,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
      ),
    );
  }
}
