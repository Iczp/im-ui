import 'package:flutter/material.dart';
import 'package:im_core/entities.dart';
import 'package:im_ui/src/models/session_menu.dart';
import 'package:logger/logger.dart';

class SessionDialog extends StatefulWidget {
  const SessionDialog({
    super.key,
    this.itemHeight = 36,
    required this.sessionUnit,
    this.width = 120,
  });

  final double width;

  final double itemHeight;

  final SessionUnit sessionUnit;

  @override
  State<SessionDialog> createState() => _SessionDialogState();
}

class _SessionDialogState extends State<SessionDialog> {
  ///
  bool get isTopping => widget.sessionUnit.isTopping;

  bool get isDisplay => widget.sessionUnit.isTopping;

  bool get isImmersed => widget.sessionUnit.isImmersed;

  bool get isDeleted => false;

  ///
  late List<SessionMenu> menus = <SessionMenu>[
    SessionMenu(
        id: 'topping', trueText: '置顶', falseText: '取消置顶', value: isTopping),
    SessionMenu(
        id: 'display', trueText: '不显示聊天', falseText: '显示聊天', value: isDisplay),
    SessionMenu(
        id: 'immersed', trueText: '免打扰', falseText: '取消免打扰', value: isImmersed),
    SessionMenu(
        id: 'delete', trueText: '删除聊天', falseText: '取消删除聊天', value: isDeleted),
  ];

  @override
  void initState() {
    super.initState();
  }

  void onMenuTap(int index) {
    Logger().d('$index:${menus[index]}');
    Navigator.pop(context);
  }

  Widget buildMenus() {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          for (var menu in menus) buildMenuItem(menu),
        ],
      ),
    );
  }

  Widget buildMenuItem(SessionMenu menu) {
    return InkWell(
      onTap: () {
        Logger().d('$menu');
        Navigator.pop(context, menu);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: widget.itemHeight,
        alignment: Alignment.centerLeft,
        child: Text(
          !menu.value ? menu.trueText : menu.falseText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: widget.width,
                height: widget.itemHeight * menus.length,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: buildMenus(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
