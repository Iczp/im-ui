import 'package:flutter/material.dart';

import 'package:im_core/im_core.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/message_arguments.dart';
import '../providers/users_provide.dart';

/// 头像
class MediaAvatar extends StatefulWidget {
  const MediaAvatar({
    Key? key,
    this.size,
    this.child,
    required this.meidaId,
    required this.meidaType,
    this.entity,
    this.onLongPressed,
    this.isDisplay = true,
    this.radius = 4,
  }) : super(key: key);

  ///
  final double radius;

  ///
  final bool isDisplay;

  /// size
  final double? size;

  /// child
  final Widget? child;

  /// defaultSize 44
  static const double defaultSize = 44;

  ///媒体Id
  final String meidaId;

  ///媒体类型
  final MediaTypeEnum meidaType;

  /// 媒体实体
  final MediaDto? entity;

  ///头像长按事件
  final MediaAvatarLongPressCallback? onLongPressed;

  @override
  State<MediaAvatar> createState() => _MediaAvatarState();
}

class _MediaAvatarState extends State<MediaAvatar> {
  final GlobalKey _globalKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  AppUserDto? mediaInfo;

  ///
  @override
  void initState() {
    //监听Widget是否绘制完毕
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _getRenderBox();
    });
    super.initState();
  }

  void _onLongPress() {
    widget.onLongPressed?.call(_globalKey, _layerLink, null);
  }

  ///
  @override
  Widget build(BuildContext context) {
    if (!widget.isDisplay) {
      return const SizedBox();
    }

    mediaInfo = context.watch<UsersProvide>().getById(widget.meidaId);

    String imageUrl = UsersProvide.imgs[0];
    if (mediaInfo != null && mediaInfo!.portrait != null) {
      imageUrl = mediaInfo!.portrait!;
    }

    return CompositedTransformTarget(
      key: _globalKey,
      link: _layerLink,
      child: Container(
        width: widget.size ?? MediaAvatar.defaultSize,
        height: widget.size ?? MediaAvatar.defaultSize,
        decoration: BoxDecoration(
          // color: const Color.fromARGB(199, 221, 221, 221),
          borderRadius: BorderRadius.circular(widget.radius),
          // //背景装饰
          gradient: const RadialGradient(
            //背景径向渐变
            colors: [
              Color.fromARGB(255, 93, 179, 255),
              Color.fromARGB(255, 63, 169, 255),
            ],
            center: Alignment.topLeft,
            radius: .98,
          ),
          // boxShadow: const [
          //   //卡片阴影
          //   BoxShadow(
          //     color: Colors.black54,
          //     // offset: Offset(2.0, 2.0),
          //     blurRadius: 2.0,
          //   )
          // ],
        ),
        child: InkWell(
          radius: widget.radius,
          borderRadius: BorderRadius.circular(widget.radius),
          onLongPress: _onLongPress,
          // onLongPress: () {
          //   if (widget.onLongPressed != null) {
          //     widget.onLongPressed!();
          //   }

          //   // _globalKey.showMenus(
          //   //   layerLink: _layerLink,
          //   // );
          //   // Toast.show(
          //   //   context: context,
          //   //   message: 'message',
          //   //   sourceKey: _key,
          //   // );
          // },
          onTap: () {
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //       builder: (context) => const PersonProfilePage(
            //         title: 'title',
            //       ),
            //     ));
          },
          // child: const Icon(
          //   Icons.person,
          //   color: Color.fromARGB(255, 245, 251, 255),
          // ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: FittedBox(
              fit: BoxFit.cover,
              child: FadeInImage(
                image: NetworkImage(
                  imageUrl,
                ),
                placeholder: MemoryImage(kTransparentImage),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
