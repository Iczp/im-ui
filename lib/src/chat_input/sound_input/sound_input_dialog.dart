import 'package:flutter/material.dart';
import 'package:im_ui/im_ui.dart';

import '../../models/sound_inputing_model.dart';
import 'sound_input_time.dart';

class SoundInputDialog extends StatefulWidget {
  const SoundInputDialog({
    Key? key,
    this.size = 180,
    this.top = 44 + 56 + 24 + 60,
    // this.soundInputing,
  }) : super(key: key);

  ///
  final double? size;

  ///
  final double top;

  // final SoundInputingModel? soundInputing;

  @override
  createState() => SoundInputDialogState();
}

class SoundInputDialogState extends State<SoundInputDialog> {
  bool _isvisible = false;

  ///限定值
  double _limit(double? input, double min, double max) {
    var value = input!;
    if (value >= max) {
      input = max;
    } else if (value <= min) {
      value = min;
    }
    return value;
  }

  double? _heightFactor = 0;
  double? _widgetLeft;

  SoundInputingModel? _soundInputing;

  ///是否准备撤回
  bool _isIntentionRollback = false;

  ///
  void update(SoundInputingModel soundInputing) {
    setState(() {
      // _isvisible = true;
      _soundInputing = soundInputing;
    });
  }

  void setIsRollback(isIntentionRollback) {
    setState(() {
      _isvisible = true;
      _isIntentionRollback = isIntentionRollback;
    });
  }

  void show() {
    setState(() {
      _isvisible = true;
    });
  }

  void hide() {
    setState(() {
      _isvisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///
    _widgetLeft = (MediaQuery.of(context).size.width - widget.size!) / 2;

    if (_soundInputing != null) {
      var decibels = _soundInputing?.decibels;

      if (decibels != null) {
        // logger.d('decibels:$decibels');
        _heightFactor = _limit((decibels - 30) / 30, 0, 1);
      }
    }

    // _heightFactor = 1;

    // logger.e('**${widget.soundInputing?.toString()}');
    return Visibility(
      visible: _isvisible,
      child: Positioned(
        left: _widgetLeft,
        top: widget.top,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: const Color.fromARGB(225, 0, 0, 0),
              borderRadius: BorderRadius.circular(10),
              // boxShadow: const [
              //   //卡片阴影
              //   BoxShadow(
              //     color: Color.fromARGB(210, 0, 0, 0),
              //     // offset: Offset(2.0, 2.0),
              //     blurRadius: 2.0,
              //   )
              // ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32,
                    // left: 32,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SoundInputTime(
                          milliseconds: _soundInputing?.milliseconds),
                      _isIntentionRollback
                          ? const MicRollback()
                          : MicSpeak(heightFactor: _heightFactor),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      height: 32,
                      child: _isIntentionRollback
                          ? const Text(
                              '松开手取消发送',
                              style: TextStyle(color: Colors.red),
                            )
                          : const Text(
                              '上滑取消',
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
                MicLine(right: 10, heightFactor: _heightFactor),
                MicLine(left: 10, heightFactor: _heightFactor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
