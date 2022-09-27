import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:im_core/im_core.dart';
import 'package:logger/logger.dart';

import '../../../models/message_arguments.dart';
import '../../../models/size_model.dart';
import '../../message_menu_buttons_all.dart';
import '../image_container.dart';
import '../message_template_widget.dart';
import '../message_widget.dart';

class ImageMessageWidget extends MessageTemplateWidget {
  ///
  final double radius;

  ///
  ImageMessageWidget({
    Key? key,
    required super.arguments,
    this.radius = 4,
  }) : super(key: key);

  @override
  State<ImageMessageWidget> createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends MessageWidgetState<ImageMessageWidget> {
  ///
  TextDirection get textDirection =>
      widget.isSelf ? TextDirection.rtl : TextDirection.ltr;

  ///内容
  ImageContentDto get img => arguments.message.getContent<ImageContentDto>();

  ///
  int get width => img.width;

  ///
  int get height => img.height;

  SizeModel? _boxSize;

  ///
  Object get heroTag => widget.message.heroTag;

  ///
  SizeModel get boxSize => _boxSize!;

  Widget? _imageWidget;

  ///
  Future<File> getFile() {
    Future.delayed(const Duration(seconds: 2));
    return Future.value(File(img.path!));
  }

  ///
  @override
  void initState() {
    _boxSize = ImageContainer.getBoxSize(img.width, img.height);
    _imageWidget = buildImageWdiget();
    super.initState();
  }

  ///
  @override
  void onMessageTap() {
    Logger().d('img:${img.width},height:${img.height}');
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
          child: FadeInImage(
            image: FileImage(File(img.path!)),
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
    return bodyGestureDetector(
      child: ImageContainer(
        contentLength: img.size,
        width: _boxSize!.width,
        height: _boxSize!.height,
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
