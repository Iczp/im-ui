import 'dart:async';

import 'package:flutter/material.dart';

import '../../commons.dart';

class RealDatetime extends StatefulWidget {
  const RealDatetime({
    super.key,
    this.dateTime,
    this.duration = const Duration(seconds: 1),
  });

  final DateTime? dateTime;

  final Duration duration;
  @override
  State<RealDatetime> createState() => _RealDatetimeState();
}

class _RealDatetimeState extends State<RealDatetime> {
  late DateTime? datetime = widget.dateTime;

  late String displayDatetime = datetime != null ? formatTime(datetime!) : '';

  late Timer _timer;

  ///
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      if (datetime != null) {
        var newDisplayDatetime = formatTime(datetime!);
        if (newDisplayDatetime != displayDatetime) {
          setState(() {});
        }
      }
    });
  }

  ///
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  ///

  @override
  Widget build(BuildContext context) {
    return Text(
      displayDatetime,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 12,
      ),
    );
  }
}