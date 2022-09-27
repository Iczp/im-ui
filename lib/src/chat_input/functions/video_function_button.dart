import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:im_core/im_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

import '../../commons/utils.dart';
import '../../models/size_model.dart';
import '../../providers/process_provide.dart';
import 'function_button.dart';

class VideoFunctionButton extends FunctionButton {
  ///

  ///
  const VideoFunctionButton({
    super.key,
    super.onSend,
  });

  ///
  @override
  String get text => '视频';

  ///
  @override
  IconData get icon => Icons.videocam_rounded;

  ///
  @override
  State<VideoFunctionButton> createState() => VideoFunctionButtonState();
}

/// VideoCompress 插件: https://pub.dev/packages/video_compress
class VideoFunctionButtonState<T extends FunctionButton>
    extends FunctionButtonState<T> {
  ///
  late Subscription _subscription;

  late ProcessProvider _processProvider;

  late double _key = 0;

  @override
  void initState() {
    _processProvider = context.read<ProcessProvider>();
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('$_key ===progress: $progress');
      _processProvider.set('123456', progress / 100);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  /// 视频缩略图大小
  Future<SizeIntModel> getImageSize(Uint8List uint8list) async {
    var thubmImage = await decodeImageFromList(uint8list);
    return SizeIntModel(thubmImage.width, thubmImage.height);
  }

  /// 保存文件
  @override
  Future<File> saveFile(Uint8List uint8list) async {
    /// 获取应用目录
    ///  String dir = (await getApplicationDocumentsDirectory()).path;
    String dir = (await getTemporaryDirectory()).path;
    var thumbFile = await File(
            '$dir/video_thumb_img_${DateTime.now().millisecondsSinceEpoch}.jpg')
        .writeAsBytes(uint8list);
    return thumbFile;
  }

  /// 视频缩略图
  Future<Uint8List?> getVideoThumb(String videoPath) async {
    /// 视频缩略图
    final uint8list = await VideoCompress.getByteThumbnail(videoPath,

        ///清晰度
        quality: 100, // default(100)
        position: -1 // default(-1)
        );
    return uint8list;
  }

  /// 压缩视频
  Future<MediaInfo?> compressVideo(String videoPath) async {
    /// 视频缩略图
    final videoInfo = await VideoCompress.compressVideo(
      videoPath,

      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false, // It's false by default
    );

    if (videoInfo == null) {
      throw FlutterError('new  videoInfo file null');
    }

    Logger().d('author:${videoInfo.author}');
    Logger().d('duration:${videoInfo.duration}');
    Logger().d('orientation:${videoInfo.orientation}');
    Logger().d('title:${videoInfo.title}');
    Logger().d('width:${videoInfo.width}');
    Logger().d('height:${videoInfo.height}');

    return videoInfo;
  }

  ///
  @override
  void onTap() async {
    Logger().d('VideoFunctionButton');

    setChatInputReadOnly();
    var items = ['拍摄', '从相册选择'];

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        double itemExtent = 56;
        BorderRadius borderRadius = BorderRadius.circular(10.0);
        return Container(
          height: (itemExtent + 8) * items.length + 8,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          child: ListView.builder(
              itemCount: items.length,
              itemExtent: itemExtent, //强制高度为50.0
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                  ),
                  child: InkWell(
                    borderRadius: borderRadius,
                    splashColor: Colors.blue.shade100,
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Navigator.pop(context);
                      });
                      handerResult(index);
                    },
                    child: Center(
                      child: Text(
                        items[index],
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Future<void> handerResult(int index) async {
    final ImagePicker picker = ImagePicker();

    final XFile? videoFile = await picker.pickVideo(
      source: index == 0 ? ImageSource.camera : ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );

    if (videoFile == null) {
      throw FlutterError('pickVideo file null');
    }

    Logger().d('path:${videoFile.path}');
    Logger().d('length:${await videoFile.length()}');
    Logger().d('mimeType:${videoFile.mimeType}');
    Logger().d('runtimeType:${videoFile.runtimeType}');

    final uint8list = await getVideoThumb(videoFile.path);

    Logger().d('uint8list:${uint8list?.lengthInBytes}');
    if (uint8list == null) {
      throw FlutterError('uint8list null');
    }

    /// 视频缩略图大小
    var thubmImage = await getImageSize(uint8list);

    /// 保存文件
    var thumbFile = await saveFile(uint8list);

    /// 视频压缩
    _key++;
    var compressedVideo = await compressVideo(videoFile.path);

    if (compressedVideo == null) {
      throw FlutterError('pickVideo file null');
    }
    // OpenFile.open(thumbFile.path);
    var sourceSize = await videoFile.length();
    var size = await compressedVideo.file!.length();
    Logger().w('原大小:${formatSize(sourceSize)},压缩后:${formatSize(size)}');
    Logger().w('pp:${(size / sourceSize).toStringAsFixed(2)}');

    ///视频信息
    final videoInfo = await VideoCompress.getMediaInfo(videoFile.path);

    var videoContent = VideoContentDto(
      //path: videoFile.path,
      path: compressedVideo.path,
      size: size,
      duration: videoInfo.duration?.toInt() ?? 0,
      width: videoInfo.height ?? 0,
      height: videoInfo.width ?? 0,
      orientation: videoInfo.orientation ?? 0,

      ///
      imagePath: thumbFile.path,
      imageSize: uint8list.lengthInBytes,
      imageWidth: thubmImage.width,
      imageHeight: thubmImage.height,
    );

    Logger().d(videoContent.toJson());

    widget.onSend?.call(videoContent);
  }
}
