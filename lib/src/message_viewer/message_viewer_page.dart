import 'dart:io';

import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

import 'package:chewie/chewie.dart';

class MessageViewerPage extends StatefulWidget {
  ///
  final List<MessageDto> messages;

  ///
  final int index;

  ///
  const MessageViewerPage({
    Key? key,
    required this.messages,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MessageViewerPage> createState() => _MessageViewerPageState();
}

class _MessageViewerPageState extends State<MessageViewerPage> {
  ///
  Color backgroundColor = Colors.black;
  bool isClose = false;

  ///
  List<MessageDto>? _messageList;

  ///
  late PageController pageController;

  ///
  late final _videoControlles = <String, VideoPlayerController>{};

  ///
  int pageIndex = 0;

  ///
  int count = 0;

  ///
  @override
  void initState() {
    super.initState();
    _messageList = widget.messages;
    pageIndex = widget.index;
    pageController = PageController(initialPage: pageIndex);

    _messageList
        ?.where((x) => [MessageTypeEnum.image, MessageTypeEnum.video]
            .contains(x.messageType))
        .forEach((message) {
      if (message.messageType == MessageTypeEnum.video) {
        var videoContent = message.getContent<VideoContentDto>();
        _videoControlles[message.autoId.toString()] =
            VideoPlayerController.file(File(videoContent.path!))
              ..initialize().then((value) => null);
        setState(() {});
        Logger().d(message.autoId);
      }
    });
    // _controller = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    Logger().d('_messageList:${_messageList?.length}');

    //显示底部栏(隐藏顶部状态栏)
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    //显示顶部栏(隐藏底部栏)
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    //隐藏底部栏和顶部状态栏
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.immersive,
    //   overlays: [
    //     SystemUiOverlay.top,
    //   ],
    // );
  }

  @override
  void dispose() {
    _messageList
        ?.where((x) => [MessageTypeEnum.image, MessageTypeEnum.video]
            .contains(x.messageType))
        .forEach((message) {
      _videoControlles[message.autoId.toString()]?.dispose();
    });
    setState(() {
      backgroundColor = Colors.transparent;
    });
    super.dispose();
  }

  Widget buildBackground() {
    if (backgroundColor == Colors.transparent) {
      return Container();
    }
    return Positioned.fill(
      child: Container(
        color: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          backgroundColor = Colors.transparent;
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            buildBackground(),
            PhotoViewGallery.builder(
              itemCount: widget.messages.length,
              scrollPhysics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              pageController: pageController,
              builder: buildItem,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              // pageController: widget.pageController,
              onPageChanged: (index) {
                pageIndex = index;
                Logger().d(index);
              },
            ),
            buildFooterBar()
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     if (count % 2 == 0) {
        //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        //       Logger().d('=========$count');
        //     } else {
        //       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        //       Logger().d('---------$count');
        //     }
        //     count++;
        //   },
        // ),
      ),
    );
  }

  ///
  ImageProvider getImage(MessageDto message) {
    String imagePath = '';
    switch (message.messageType) {
      case MessageTypeEnum.image:
        imagePath = message.getContent<ImageContentDto>().path!;
        break;
      case MessageTypeEnum.video:
        imagePath = message.getContent<VideoContentDto>().imagePath!;
        break;
      default:
    }

    return FileImage(File(imagePath));
  }

  ///
  Widget buildFooterBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '20.456M',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.download,
                  color: Colors.white70,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.grid_view,
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  PhotoViewGalleryPageOptions buildItem(BuildContext context, int index) {
    var message = widget.messages[index];
    if (message.messageType == MessageTypeEnum.video) {
      return chewieVideoMessageViewer(message);
      // return videoMessageViewer(message);
    } else {
      return imageMessageViewer(message);
    }
  }

  PhotoViewGalleryPageOptions imageMessageViewer(MessageDto message) {
    return PhotoViewGalleryPageOptions(
      imageProvider: getImage(message),
      minScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: message.heroTag),
    );
  }

  PhotoViewGalleryPageOptions videoMessageViewer(MessageDto message) {
    ///
    var videoController = _videoControlles[message.autoId.toString()]!;

    ///
    var videoContent = message.getContent<VideoContentDto>();

    Logger().d('videoController:$videoController');

    ///
    return PhotoViewGalleryPageOptions.customChild(
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
      disableGestures: true,
      tightMode: true,
      // ignore: prefer_const_constructors
      child: Center(
        child: AspectRatio(
            aspectRatio: videoContent.width /
                videoContent.height, //videoController!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Hero(
                  tag: message.heroTag,
                  child: VideoPlayer(videoController),
                ),
                _ControlsOverlay(
                  controller: videoController,
                ),
                VideoProgressIndicator(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  videoController,
                  allowScrubbing: false,
                )
              ],
            )),
      ),
      onTapDown: (context, details, controllerValue) {
        Logger().d(controllerValue.position);
      },
    );
  }

  ///
  PhotoViewGalleryPageOptions chewieVideoMessageViewer(MessageDto message) {
    ///
    var videoController = _videoControlles[message.autoId.toString()]!;

    ///
    var videoContent = message.getContent<VideoContentDto>();

    Logger().d('chewieVideoMessageViewer:$videoController');

    final videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    videoPlayerController.initialize().then((value) => null);

    final chewieController = ChewieController(
      // aspectRatio: videoContent.width / videoContent.height,
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    ///
    return PhotoViewGalleryPageOptions.customChild(
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
      disableGestures: true,
      tightMode: true,
      // ignore: prefer_const_constructors
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const Center(
                  child: Icon(
                    Icons.play_circle_outline_outlined,
                    color: Colors.white70,
                    size: 72.0,
                    semanticLabel: 'Play',
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
              controller.play();
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
