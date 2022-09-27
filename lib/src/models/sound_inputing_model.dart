///语音输入
typedef SoundInputingCallback = void Function(SoundInputingModel);

///语音输入
class SoundInputingModel {
  const SoundInputingModel({
    this.decibels,
    required this.milliseconds,
    required this.startTime,
  });

  ///分贝
  final double? decibels;

  ///时间
  final int milliseconds;

  ///开始时间
  final DateTime startTime;
}
