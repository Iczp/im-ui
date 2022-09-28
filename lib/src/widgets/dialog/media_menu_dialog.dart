import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import '../../menus/menu_button.dart';

///头像右键菜单
class MediaMenuDialog extends StatefulWidget {
  const MediaMenuDialog({
    Key? key,
    this.layerLink,
    this.isSelf = false,
    this.child,
    this.sourceKey,
    required this.isDisplay,
    this.onMenuTap,
  }) : super(key: key);

  const MediaMenuDialog.show({
    Key? key,
    this.isDisplay = false,
    required this.layerLink,
    this.isSelf = false,
    this.child,
    required this.sourceKey,
    this.onMenuTap,
  }) : super(key: key);

  static String caller = 'MediaMenuDialog';

  ///
  final bool isDisplay;

  ///
  final GlobalKey? sourceKey;

  ///
  final LayerLink? layerLink;

  ///
  final bool isSelf;

  ///
  final Widget? child;

  ///
  final MenuItemTapCallback? onMenuTap;

  ///
  @override
  State<MediaMenuDialog> createState() => _MediaMenuDialogState();
}

class _MediaMenuDialogState extends State<MediaMenuDialog> {
  ///
  void _onTap(MenuButton menuItem) {
    widget.onMenuTap?.call(menuItem);
  }

  @override
  void initState() {
    super.initState();
  }

  ///
  List<Widget> buildMenus() {
    return [
      MenuButton(
        iconData: Icons.waving_hand,
        text: '拍Ta',
        code: MenuTypeEnum.slapped,
        onTap: _onTap,
      ),
      MenuButton(
        iconData: Icons.alternate_email,
        text: '我',
        code: MenuTypeEnum.reminderMe,
        onTap: _onTap,
      ),
    ];
  }

  ///
  @override
  Widget build(BuildContext context) {
    // logger.d('isSelf:${widget.isSelf}');

    ///
    if (!widget.isDisplay ||
        widget.layerLink == null ||
        widget.sourceKey == null ||
        widget.sourceKey!.currentContext == null) {
      return const SizedBox();
    }

    ///
    var globalKey = widget.sourceKey!;
    //获取`RenderBox`对象
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(const Offset(0, 0));
    // debugPrint("----------positions of red:$offset");
    final size = renderBox.size;
    // debugPrint("----------size of red:$size");

    return Positioned(
      // right: 0,
      top: offset.dy,
      child: CompositedTransformFollower(
        link: widget.layerLink!,
        followerAnchor: widget.isSelf ? Alignment.topRight : Alignment.topLeft,
        offset: Offset(widget.isSelf ? 0 : size.width, 0),
        child: Material(
          color: Colors.transparent,
          child: Bubble(
            nip: widget.isSelf ? BubbleNip.rightCenter : BubbleNip.leftCenter,
            color: const Color.fromARGB(225, 0, 0, 0),
            child: Flex(
              direction: Axis.horizontal,
              children: buildMenus(),
            ),
          ),
        ),
      ),
    );
  }
}
