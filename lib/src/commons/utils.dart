import 'dart:developer';
import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

/// 格式化时间
String formatDuration(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours == 0) {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

/// 格式化文件大小
String formatSize(dynamic size, [int round = 2]) {
  return filesize(size, round);
}

String formatTime(DateTime dateTime) {
  Logger().d('dateTime.weekday:${dateTime.weekday}');
  if (Utils.isToday(dateTime)) {
    return DateFormat("HH:mm").format(dateTime);
  }
  if (Utils.isCurrentWeek(dateTime)) {
    return DateFormat("EEEE HH:mm").format(dateTime) +
        ' ' +
        dateTime.weekday.toString();
  }
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
}

class Utils {
  ///振动
  static void vibrate() {
    log('vibrate');
    if (Platform.isAndroid || Platform.isIOS) {
      // Vibrate.vibrate();
      // Vibrate.vibrateWithPauses([
      //   const Duration(milliseconds: 500),
      // ]);
      Vibrate.feedback(FeedbackType.success);
    } else {
      log('vibrate **');
    }
  }

  ///振动反馈
  static void vibrateFeedBack(FeedbackType feedbackType) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Vibrate.vibrate();
      // Vibrate.vibrateWithPauses([
      //   const Duration(milliseconds: 500),
      // ]);
      Vibrate.feedback(feedbackType);
    } else {
      Logger().w('feedback $feedbackType');
    }
  }

  ///振动反馈: sussess
  static void vibrateSuccess() {
    vibrateFeedBack(FeedbackType.success);
  }

  ///振动反馈: sussess
  static void vibrateIfSuccess(VoidCallback? callback) {
    if (callback != null) {
      callback();
      vibrateFeedBack(FeedbackType.success);
    }
  }

  ///振动反馈: error
  static void vibrateError() {
    vibrateFeedBack(FeedbackType.error);
  }

  static bool isToday(DateTime dateTime, {DateTime? dateTime2}) {
    var now = dateTime2 ?? DateTime.now();
    var diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(dateTime.year, dateTime.month, dateTime.day));

    return diff.inDays == 0;
  }

  static bool isCurrentWeek(DateTime dateTime) {
    return true;
  }
}
