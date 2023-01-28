//通过 Overlay 实现 Toast
import 'package:flutter/material.dart';

class Toast {
  static void show(
      {required BuildContext context,
      required String message,
      required GlobalKey sourceKey}) {
    if (sourceKey.currentContext == null) {
      return;
    }
    //获取`RenderBox`对象
    RenderBox renderBox =
        sourceKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(const Offset(0, 0));
    debugPrint("positions of red:$offset");

    final size = renderBox.size;
    //输出背景为红色的widget的宽高
    debugPrint("size of red:$size");

    //1、创建 overlayEntry
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
            left: 0,
            top: offset.dy,
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Center(
                  child: Card(
                    color: Colors.grey.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(message),
                    ),
                  ),
                ),
              ),
            ));
      },
    );

    //插入到 Overlay中显示 OverlayEntry
    Overlay.of(context).insert(overlayEntry);

    //延时两秒，移除 OverlayEntry
    Future.delayed(const Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}
