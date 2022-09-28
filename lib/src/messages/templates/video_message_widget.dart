import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:im_core/im_core.dart';

import '../../commons/utils.dart';
import '../../models/message_arguments.dart';
import '../../models/size_model.dart';
import '../../providers/process_provide.dart';
import '../../widgets/message_menu_buttons_all.dart';
import '../containers/image_container.dart';
import 'message_template_widget.dart';
import '../message_widget.dart';

///
class VideoMessageWidget extends MessageTemplateWidget {
  ///
  final double radius;

  ///
  VideoMessageWidget({
    Key? key,
    required super.arguments,
    this.radius = 4,
  }) : super(key: key);

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

///
class _VideoMessageWidgetState extends MessageWidgetState<VideoMessageWidget> {
  ///
  TextDirection get textDirection =>
      widget.isSelf ? TextDirection.rtl : TextDirection.ltr;

  ///内容
  VideoContentDto get video => arguments.message.getContent<VideoContentDto>();

  ///
  int get width => video.width;

  ///
  int get height => video.height;

  SizeModel? _boxSize;

  ///
  Object get heroTag => widget.message.heroTag;

  ///
  SizeModel get boxSize => _boxSize!;

  ///
  String get durationText => formatDuration(video.duration);

  ///
  Widget? _imageWidget;

  ///
  Future<File> getFile() {
    Future.delayed(const Duration(seconds: 2));
    return Future.value(File(video.path!));
  }

  ///
  @override
  void initState() {
    _boxSize = ImageContainer.getBoxSize(video.width, video.height);
    _imageWidget = buildImageWdiget();
    super.initState();
  }

  ///
  @override
  void onMessageTap() {
    Logger().d('video:${video.toJson()}');
    Logger().d(video.toJson());
    Logger().d('box width:${boxSize.width},box height:${boxSize.height}');
    super.onMessageTap();
    navToMessageViewer();
  }

  Widget buildImageWdiget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: FittedBox(
        child: Hero(
          tag: heroTag,
          // child: Image.file(File(video.imagePath!)),
          child: FadeInImage(
            image: FileImage(File(video.imagePath!)),
            placeholder: MemoryImage(kTransparentImage),
          ),
        ),
      ),
    );
  }

  ///
  @override
  Widget buildMessageContentWidget(BuildContext context) {
    // return Text('data');

    // var duration = Duration(milliseconds: video.duration);
    // duration.toString();

    return bodyGestureDetector(
      child: ImageContainer(
        contentLength: video.size,
        width: _boxSize!.width,
        height: _boxSize!.height,
        topWidget: Text(
          durationText,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
        // centerWidget: const Icon(
        //   Icons.play_circle_outline_rounded,
        //   color: Colors.white,
        //   size: 32,
        // ),
        centerWidget: Center(
          child: Selector<ProcessProvider, double?>(
            selector: (_, processProvider) => processProvider.get('123456'),
            builder: (context, value, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${(value! * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  CircularProgressIndicator(
                    color: Colors.white.withAlpha(200),
                    backgroundColor: Colors.grey.withAlpha(50),
                    strokeWidth: 2,
                    // valueColor: Colors.red,
                    value: value,
                  )
                ],
              );
            },
          ),
        ),
        child: _imageWidget,
      ),
    );
  }

  void aaa() {
    FutureBuilder(
      future: getFile(),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            return ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: FittedBox(
                child: Image.file(snapshot.data!),
              ),
            );
          }
        }
        // 请求未结束，显示loading
        return const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.black26,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  ///
  @override
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments) => [
        // CopyMessageMenuButton(arguments),
        QuoteMessageMenuButton(arguments),
        // SoundPlayMessageMenuButton(arguments),
        // ForwardMessageMenuButton(arguments),
        FavoriteMessageMenuButton(arguments),
        // ReminderMessageMenuButton(arguments),
        // HeadphonesMessageMenuButton(arguments),
        ChoiceMessageMenuButton(arguments),
        RollbackMessageMenuButton(arguments),
        ShareMessageMenuButton(arguments),
      ];
}
