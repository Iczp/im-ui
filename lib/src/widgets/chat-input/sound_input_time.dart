import 'package:flutter/material.dart';

class SoundInputTime extends StatelessWidget {
  const SoundInputTime({
    Key? key,
    this.milliseconds,
  }) : super(key: key);
  final int? milliseconds;

  ///转换时间
  String _convertToTime(int? milliseconds) {
    if (milliseconds == null) {
      return '00:00';
    }
    var duration = Duration(milliseconds: milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    String time = _convertToTime(milliseconds);
    var color = Colors.white;
    if (milliseconds != null) {
      if (milliseconds! > 30000) {
        color = const Color.fromARGB(142, 255, 63, 60);
      } else if (milliseconds! > 15000) {
        // ignore: prefer_const_constructors
        color = Color.fromARGB(176, 252, 220, 90);
      }
    }

    return SizedBox(
      height: 56,
      child: Center(
        child: Text(
          time,
          style: TextStyle(
            color: color,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
