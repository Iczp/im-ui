import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenshotWidget extends StatefulWidget {
  const ScreenshotWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  _ScreenshotWidgetState createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  GlobalKey globalKey = GlobalKey();
  Image? _image;
  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    }

    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _printPngBytes() async {
    var pngBytes = await _capturePng();
    _image = Image.memory(pngBytes);
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _printPngBytes,
                child:
                    const Text('Capture Png', textDirection: TextDirection.ltr),
              ),
              widget.child,
            ],
          ),
        ),
        if (_image != null) _image!
      ],
    );
  }
}
