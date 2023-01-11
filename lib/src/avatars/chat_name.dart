import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:provider/provider.dart';

import '../providers/users_provide.dart';

// class UserNameWidget extends StatefulWidget {
//   const UserNameWidget({Key? key}) : super(key: key);

//   @override
//   State<UserNameWidget> createState() => _UserNameWidgetState();
// }

// class _UserNameWidgetState extends State<UserNameWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Text(
//       '陈忠培@信息中心/开发部',
//       textAlign: TextAlign.end,
//       style: TextStyle(fontSize: 12, color: Color.fromARGB(124, 98, 98, 98)),
//     );
//   }
// }

/// 用户名称
class ChatName extends StatelessWidget {
  const ChatName({
    Key? key,
    this.style,
    this.user,
    this.mediaId,
    this.mediaType,
    this.isAnimated,
    this.isDisplay = true,
  }) : super(key: key);

  ///用户
  final AppUserDto? user;

  final bool? isAnimated;

  ///
  final String? mediaId;

  ///
  final MediaTypeEnum? mediaType;

  ///用户名
  String? get name => user?.name;

  ///
  final TextStyle? style;

  final bool isDisplay;

  @override
  Widget build(BuildContext context) {
    if (!isDisplay) {
      return const SizedBox();
    }

    var mediaName = '';
    var mediaInfo = context.read<UsersProvide>().getById(mediaId!);
    if (mediaInfo != null) {
      mediaName = mediaInfo.name;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        // width: 120.0,
        height: 24,
        child: Center(
          widthFactor: 1,
          child: Text(
            mediaName,
            // textAlign: TextAlign.start,
            // textAlign: TextAlign.center,
            style: style ??
                const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
        // child: AnimatedTextKit(
        //   isRepeatingAnimation: false,
        //   animatedTexts: [
        //     WavyAnimatedText('陈忠培'),
        //     // WavyAnimatedText('Look at the waves'),
        //   ],
        //   onTap: () {
        //     log("Tap Event");
        //   },
        // ),
        // child: TextLiquidFill(
        //   text: 'LIQUIDY',
        //   waveColor: Colors.blueAccent,
        //   boxBackgroundColor: Color.fromARGB(255, 237, 237, 237),
        //   textStyle: TextStyle(
        //       // fontSize: 80.0,
        //       // fontWeight: FontWeight.bold,
        //       ),
        //   boxHeight: 22.0,
        // ),
      ),
    );
  }
}
