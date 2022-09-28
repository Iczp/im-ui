import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import '../menus/menu_button.dart';
import 'operation_bar.dart';

class OperationMenus extends StatefulWidget {
  ///
  final Color? color;

  ///
  final MenuItemTapCallback? onMenuTap;

  const OperationMenus({
    Key? key,
    this.color,
    this.onMenuTap,
  }) : super(key: key);

  @override
  State<OperationMenus> createState() => _OperationMenusState();
}

class _OperationMenusState extends State<OperationMenus> {
  ///

  ///
  Widget buildMenuItem(MenuTypeEnum code, IconData iconData, String text) {
    return Expanded(
      // widthFactor: 1,
      child: MenuButton(
        color: widget.color,
        direction: Axis.vertical,
        iconData: iconData,
        text: text,
        code: code,
        iconSize: 24,
        textSize: 12,
        onTap: widget.onMenuTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OperationBar(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildMenuItem(MenuTypeEnum.more, Icons.share, '更多'),
        buildMenuItem(MenuTypeEnum.delete, Icons.remove_done_sharp, '删除'),
        buildMenuItem(MenuTypeEnum.delete, Icons.delete, '删除'),
        buildMenuItem(
            MenuTypeEnum.cancle, Icons.cancel_presentation_rounded, '取消'),
      ],
    ));
  }
}
