import 'package:flutter/material.dart';
import '../../commons/utils.dart';
import '../../models/size_model.dart';

///
class ImageContainer extends StatelessWidget {
  ///
  final double radius;

  ///
  final double width;

  ///
  final double height;

  ///
  final Widget? child;

  ///
  final Widget? centerWidget;

  ///
  final Widget? topWidget;

  ///
  final int contentLength;

  ///
  String get filesizeFormat => formatSize(contentLength);

  ///
  static const double maxHeight = 150;

  ///
  static const double maxWidth = 200;

  ///
  static SizeModel getBoxSize(int width, int height) {
    if (width > height) {
      return SizeModel(
          ImageContainer.maxWidth, ImageContainer.maxWidth * height / width);
    } else if (width < height) {
      return SizeModel((ImageContainer.maxHeight * width) / height,
          ImageContainer.maxHeight);
    }
    return SizeModel(ImageContainer.maxHeight, ImageContainer.maxHeight);
  }

  ///
  const ImageContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.contentLength,
    this.radius = 4,
    this.child,
    this.centerWidget,
    this.topWidget,
  }) : super(key: key);

  Widget buildCenterWidget() {
    if (centerWidget == null) {
      return const SizedBox();
    }
    return Positioned.fill(
      child: centerWidget!,
    );
  }

  Widget buildTopWidget() {
    if (topWidget == null) {
      return const SizedBox();
    }
    return Positioned(
      right: 2,
      top: 2,
      child: topWidget!,
    );
  }

  Widget buildBottomWidget() {
    return Positioned(
      // left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [
        //         Color.fromARGB(0, 0, 0, 0),
        //         Color.fromARGB(100, 0, 0, 0)
        //       ]),
        // ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            filesizeFormat,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 0.25,
          ),
          borderRadius: BorderRadius.circular(radius)),
      child: Stack(
        // alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: height,
            constraints: const BoxConstraints(
              maxHeight: ImageContainer.maxHeight,
              maxWidth: ImageContainer.maxWidth,
            ),
            child: child,
          ),
          buildTopWidget(),
          buildCenterWidget(),
          buildBottomWidget()
        ],
      ),
    );
  }
}
