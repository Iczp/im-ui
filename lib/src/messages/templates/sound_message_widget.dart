import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

import '../../models/message_arguments.dart';
import '../../widgets/message_menu_buttons_all.dart';
import '../../widgets/wifi_icon.dart';
import '../containers/bubble_container.dart';
import 'message_item_widget.dart';
import '../message_widget.dart';

class SoundMessageWidget extends MessageItemWidget {
  ///
  final double maxWidth;

  ///
  SoundMessageWidget({
    super.key,
    required super.arguments,
    this.maxWidth = 240,
  });

  // ///
  // bool get isSoundPlay => arguments.isSoundPlay;

  ///
  SoundContentDto get content => message.getContent<SoundContentDto>();

  ///
  @override
  State<SoundMessageWidget> createState() => _SoundMessageWidgetState();
}

class _SoundMessageWidgetState extends MessageWidgetState<SoundMessageWidget> {
  ///
  TextDirection get textDirection =>
      widget.isSelf ? TextDirection.rtl : TextDirection.ltr;

  @override
  List<MessageMenuButton> buildMessageMenus(MessageArguments arguments) => [
        // CopyMessageMenuButton(arguments),
        QuoteMessageMenuButton(arguments),
        SoundPlayMessageMenuButton(arguments),
        ForwardMessageMenuButton(arguments),
        FavoriteMessageMenuButton(arguments),
        ReminderMessageMenuButton(arguments),
        HeadphonesMessageMenuButton(arguments),
        ChoiceMessageMenuButton(arguments),
        RollbackMessageMenuButton(arguments),
        ShareMessageMenuButton(arguments),
      ];

  ///
  int get time => (widget.content.time! ~/ 1000).toInt();

  ///
  String get timeText => '$time "';

  ///
  double get maxWidth => widget.maxWidth;
  int get maxSeconds => 60;
  @override
  Widget buildMessageContentWidget(BuildContext context) {
    // logger.d('sound body- ${toString()} -isPlayed:$isPlayed');

    double? width = (time / maxSeconds) * maxWidth;

    if (time < 3 || time > maxSeconds) {
      width = null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: textDirection,
      children: [
        bodyGestureDetector(
            child: BubbleContainer(
          isHover: isHover,
          isSelf: widget.isSelf,
          child: Container(
            // widthFactor: 0.2,
            width: width,
            constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: maxWidth,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize:
                  time < maxSeconds ? MainAxisSize.min : MainAxisSize.max,
              textDirection: textDirection,
              children: [
                WifiIcon(
                  isPlay: widget.isSoundPlay,
                  isSelf: widget.isSelf,
                ),
                Text(
                  timeText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(152, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        )),
        !widget.isSelf && !isPlayed
            ? const badges.Badge(
                // showBadge: true,
                // toAnimate: false,
                // elevation: 0,
                )
            : const SizedBox(),
      ],
    );
  }
}
