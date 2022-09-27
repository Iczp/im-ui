import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:im_core/im_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../../commons/utils.dart';
import '../chat_input.dart';
import 'function_button_widget.dart';

///
abstract class FunctionButton<TMessageContent extends MessageContent>
    extends StatefulWidget {
  ///

  ///
  const FunctionButton({
    super.key,
    this.onSend,
  });

  ///
  String get text => '拍照';

  ///
  IconData get icon => Icons.camera_alt;

  ///发送
  final ValueChanged<TMessageContent>? onSend;

  ///
  @override
  State<FunctionButton> createState() => FunctionButtonState();
}

class FunctionButtonState<T extends FunctionButton> extends State<T> {
  /// 输入框设置为已读 防止返回页时，弹出软键盘，导致页面抖动
  void setChatInputReadOnly() {
    Logger().d('setChatInputReadOnly');
    ChatInputState.of(context)?.setReadOnly(true);
  }

  ///
  void onTap() {
    Logger().d('supper FunctionButtonState');
    widget.onSend?.call(buildContent());
  }

  ///
  MessageContent buildContent() {
    throw UnimplementedError('未实现 buildContent.');
  }

  ///
  void pickImageFromCamera() {
    _pickImage(ImageSource.camera);
  }

  ///
  void pickImageFromGallery() {
    _pickImage(ImageSource.gallery);
  }

  /// 保存文件
  Future<File> saveFile(Uint8List uint8list) async {
    /// 获取应用目录
    ///  String dir = (await getApplicationDocumentsDirectory()).path;
    String dir = (await getTemporaryDirectory()).path;
    var thumbFile = await File(
            '$dir/image_thumb_img_${DateTime.now().millisecondsSinceEpoch}.jpg')
        .writeAsBytes(uint8list);
    return thumbFile;
  }

  Future<File> compressFile(String filePath) async {
    String dir = (await getTemporaryDirectory()).path;
    var targetPath =
        '$dir/image_thumb_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    var file = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      // minWidth: 1080,
      // minHeight: 1920,
      quality: 95,
    );
    Logger().d(file!.length);
    return file;
  }

  ///
  void _pickImage(ImageSource source) async {
    Logger().d('_pickImage:$source');
    setChatInputReadOnly();
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1920,
      // imageQuality: quality,
    );
    Logger().d('pickImage path:${pickedFile?.path}');
    Logger().d('pickImage length:${await pickedFile?.length()}');
    Logger().d('pickImage mimeType:${pickedFile?.mimeType}');
    Logger().d('pickImage runtimeType:${pickedFile?.runtimeType}');

    var compressedFile = await compressFile(pickedFile!.path);
    var sourceSize = await pickedFile.length();
    var size = await compressedFile.length();
    Logger().w('原大小:${formatSize(sourceSize)},压缩后:${formatSize(size)}');
    Logger().w('p:${(size / sourceSize).toStringAsFixed(2)}');

    var decodedImage =
        await decodeImageFromList(await compressedFile.readAsBytes());
    var messageContent = ImageContentDto(
      path: compressedFile.path,
      size: await compressedFile.length(),
      width: decodedImage.width,
      height: decodedImage.height,
    );
    Logger().d(messageContent);
    widget.onSend?.call(messageContent);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return FunctionButtonWidget(
      direction: Axis.vertical,
      color: Colors.black87,
      iconData: widget.icon,
      text: widget.text,
      disabled: false,
      iconSize: 36,
      width: 56,
      onTap: onTap,
    );
  }
}
