typedef SoundSuccessCallback = void Function(SoundInputedModel);

/// 语音输入
class SoundInputedModel {
  const SoundInputedModel({
    required this.filePath,
    required this.duration,
  });

  ///文件地址(除了手机设备有值，其他null)
  final String filePath;

  ///时长（毫秒）
  final int duration;

  ///是否成功
  bool isSuccess() {
    return filePath.isNotEmpty && duration > 0;
  }
}
