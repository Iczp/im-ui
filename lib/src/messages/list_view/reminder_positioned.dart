import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ReminderPositioned extends StatefulWidget {
  const ReminderPositioned({
    Key? key,
    this.top,
    this.bottom,
    this.title,
  }) : super(key: key);

  final double? top;
  final double? bottom;

  final String? title;

  @override
  State<ReminderPositioned> createState() => ReminderPositionedState();
}

class ReminderPositionedState extends State<ReminderPositioned>
    with SingleTickerProviderStateMixin {
  late final Color _color = const Color.fromARGB(255, 0, 138, 231);
  late final TextStyle _textStyle = TextStyle(
    fontSize: 12.0,
    color: _color,
  );

  double? get top => widget.top;
  double? get bottom => widget.bottom;
  late String title = '';

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(1, 0.0),
    end: const Offset(0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  ));

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      Logger().d(status);
    });
  }

  void show(String value) {
    title = value;
    setState(() {});
    _controller.forward();
  }

  void hide() {
    setState(() {});
  }

  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: top,
      bottom: bottom,
      child: SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onTap: () {
            _controller.reverse();
          },
          child: Container(
            // height: 50,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(190, 238, 238, 238),
              border: Border.all(
                color: const Color.fromARGB(206, 0, 139, 231),
                width: 0.5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              // boxShadow: const [
              //   //卡片阴影
              //   BoxShadow(
              //     color: Color.fromARGB(211, 187, 187, 187),
              //     // offset: Offset(2.0, 2.0),
              //     blurRadius: 2.0,
              //   )
              // ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  top != null
                      ? Icons.keyboard_double_arrow_up
                      : Icons.keyboard_double_arrow_down,
                  size: 12.0,
                  color: _color,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: _textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
