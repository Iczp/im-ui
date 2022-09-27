import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../commons/utils.dart';
import '../../models/sound_inputed_model.dart';
import '../../models/sound_inputing_model.dart';
import 'sound_input_dialog.dart';

/*
 *
 * This is a very simple example for Flutter Sound beginners,
 * that show how to record, and then playback a file.
 *
 * This example is really basic.
 *
 */

// typedef SoundInputingCallback = void Function(SoundInputingModel);
// typedef SoundSuccessCallback = void Function(SoundSuccessModel);

class SoundInputContainer extends StatefulWidget {
  const SoundInputContainer({
    Key? key,
    // this.onSoundInput,
    this.distance = 80,
    this.onSlideChanged,
    this.color = const Color.fromARGB(255, 223, 223, 223),
    this.holdColor = const Color.fromARGB(255, 107, 176, 244),
    this.rollbackColor = const Color.fromARGB(255, 167, 167, 167),
    this.subscriptionDuration,
    this.onSoundInputing,
    this.onSuccess,
    this.minSeconds = 3,
    this.maxSeconds = 60,
  }) : super(key: key);

  // ///语音输入事件
  // final ValueChanged<bool>? onSoundInput;

  ///
  final double minSeconds;

  ///
  final double maxSeconds;

  ///滑动距离
  final double distance;

  ///默认颜色
  final Color color;

  ///按住颜色
  final Color holdColor;

  ///撤回颜色
  final Color rollbackColor;

  ///按钮滑动事件
  final ValueChanged<bool>? onSlideChanged;

  ///订阅事件间隔(录音分贝变化)
  final double? subscriptionDuration;

  ///录音分贝变化
  final SoundInputingCallback? onSoundInputing;

  ///成功
  final SoundSuccessCallback? onSuccess;

  @override
  State<SoundInputContainer> createState() => _SoundInputContainerState();
}

class _SoundInputContainerState extends State<SoundInputContainer> {
  ///
  double dy = 0;

  ///
  bool _isRollback = false;

  ///
  bool _isPressed = false;

  ///
  final GlobalKey<SoundInputDialogState> _micDialogKey = GlobalKey();

  ///
  SoundInputingModel? _soundInputing;

  ///
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  ///
  Codec _codec = Codec.aacMP4;

  ///
  // String _mPath = 'tau_file.mp4';
  ///
  StreamSubscription? _recorderSubscription;

  ///
  DateTime? _startTime;

  ///
  int pos = 0;

  ///
  double dbLevel = 0;

  ///
  late final OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) {
      return SoundInputDialog(
        key: _micDialogKey,
        // soundInputing: _soundInputing,
      );
    },
  );

  ///
  void setIsRollback(isRollback) {
    if (_isRollback != isRollback) {
      _isRollback = isRollback;
      widget.onSlideChanged?.call(_isRollback);
      _micDialogKey.currentState!.setIsRollback(_isRollback);
    }
  }

  void updateIsPressed(bool isPressed) {
    if (_isPressed != isPressed) {
      setState(() {
        _isPressed = isPressed;
      });
    }

    // widget.onSoundInput?.call(isPressed);
  }

  @override
  void initState() {
    super.initState();
    initRecorder().then((value) {
      Overlay.of(context)!.insert(overlayEntry);

      ///订阅事件
      setSubscriptionDuration(widget.subscriptionDuration ?? 300);
    });
  }

  @override
  void dispose() {
    // stopRecorder(_recorder);
    cancelRecorderSubscriptions();

    // Be careful : you must `close` the audio session when you have finished with it.
    _recorder.closeRecorder();

    overlayEntry.remove();
    super.dispose();
  }

  ///取消订阅事件
  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  ///打开录音机
  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _recorder.openRecorder();
    if (!await _recorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      // _mPath = 'tau_file.webm';
      if (!await _recorder.isEncoderSupported(_codec) && kIsWeb) {
        return;
      }
    }

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  ///初始化录音机
  Future<void> initRecorder() async {
    await openTheRecorder();
    _recorderSubscription = _recorder.onProgress!.listen((e) {
      setState(() {
        pos = e.duration.inMilliseconds;
        if (e.decibels != null) {
          dbLevel = e.decibels as double;
        }

        // Logger().d('onInputing:${e.duration.inMilliseconds},${e.decibels}');

        _soundInputing = SoundInputingModel(
          decibels: e.decibels,
          milliseconds: e.duration.inMilliseconds,
          startTime: _startTime!,
        );
        _micDialogKey.currentState?.update(_soundInputing!);
        widget.onSoundInputing?.call(_soundInputing!);
      });
    });
  }

  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  // -------  Here is the code to playback  -----------------------

  void record(FlutterSoundRecorder? recorder) async {
    await recorder!.startRecorder(
      codec: _codec,
      toFile: 'record-${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    _startTime = DateTime.now();
    // setState(() {});
  }

  Future<void> stopRecorder(FlutterSoundRecorder recorder) async {
    /// 未录音
    if (recorder.isStopped) {
      return;
    }

    ///
    var filePath = await recorder.stopRecorder();
    if (filePath!.isEmpty) {
      Logger().e('filePath is empty');
      return;
    }

    /// 用户取消
    if (_isRollback) {
      return;
    }

    var s = _startTime!.millisecondsSinceEpoch;
    int duration = (DateTime.now().millisecondsSinceEpoch - s);

    Logger().w('filePath:$filePath,time:$duration');

    if (widget.onSuccess != null) {
      widget.onSuccess!(
          SoundInputedModel(duration: duration, filePath: filePath));
    }
  }

  Future<void> setSubscriptionDuration(

      ///v is between 0.0 and 2000 (milliseconds)
      double milliseconds) async // v is between 0.0 and 2000 (milliseconds)
  {
    await _recorder.setSubscriptionDuration(
      Duration(milliseconds: milliseconds.floor()),
    );
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onPanCancel: () {
          Logger().i("onPanCancel");
          updateIsPressed(false);
          _micDialogKey.currentState?.hide();
        },
        onPanDown: (details) {
          Logger().d('onPanDown:${details.localPosition.dy}');
          dy = details.localPosition.dy;
          _micDialogKey.currentState?.show();
          updateIsPressed(true);
          setIsRollback(false);
          Utils.vibrate();
          record(_recorder);
        },
        onPanEnd: (details) async {
          Logger().d('onPanEnd:$details');
          updateIsPressed(false);
          stopRecorder(_recorder);
          _micDialogKey.currentState?.hide();
        },
        onPanUpdate: (details) {
          // Logger().d('onPanUpdate:${details.localPosition.dy}');
          var distanceY = details.localPosition.dy - dy;
          setIsRollback(distanceY.abs() > widget.distance);
        },
        child: Container(
          padding: const EdgeInsets.all(2.5),
          margin: const EdgeInsets.only(
            bottom: 2.5,
          ),
          decoration: BoxDecoration(
              color: _isPressed
                  ? (_isRollback ? widget.rollbackColor : widget.holdColor)
                  : widget.color,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: _isPressed
                  ? const [
                      //卡片阴影
                      BoxShadow(
                        color: Color.fromARGB(77, 0, 0, 0),
                        // offset: Offset(2.0, 2.0),
                        blurRadius: 2.0,
                      ),
                    ]
                  : null),
          constraints: const BoxConstraints(
            minHeight: 36.0,
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mic,
                size: 18,
              ),
              Text(
                _isPressed ? '正在录音...' : '按住 说话',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
