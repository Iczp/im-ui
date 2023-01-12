import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:im_core/entities.dart';
import 'package:im_ui/src/avatars/chat_avatar.dart';
import 'package:im_ui/src/providers/session_unit_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../nav.dart';
import '../commons/utils.dart';
import '../widgets/expand.dart';
import '../widgets/immersed_icon.dart';
import '../widgets/session_layout.dart';

class SessionUnitItem extends StatefulWidget {
  ///
  const SessionUnitItem({
    super.key,
    required this.data,
  });

  ///
  final SessionUnit data;

  @override
  State<SessionUnitItem> createState() => SessionUnitItemState();
}

///
class SessionUnitItemState extends State<SessionUnitItem> {
  ///
  SessionUnit get item => widget.data;

  GlobalKey get globalKey => item.globalKey;

  ChatObject? get dest => widget.data.destination;

  String get title => item.rename ?? dest?.name ?? '';

  MessageDto? get lastMessage => item.lastMessage;

  String get subtitle =>
      '[${dest?.objectType.toString()}] ${item.sorting}|| lastMessageAutoId:${item.lastMessageAutoId}-autoId:${lastMessage?.autoId}';

  DateTime? get sendTime => lastMessage?.creationTime ?? DateTime.now();

  String get sendTimeDisplay => sendTime != null ? formatTime(sendTime!) : '';

  // int get badge => item.badge ?? 0;

  bool get isImmersed => item.isImmersed;

  int get reminderAllCount => item.reminderAllCount ?? 0;

  int get reminderMeCount => item.reminderMeCount ?? 0;

  bool get isRemind => reminderMeCount + reminderAllCount > 0;

  ///
  @override
  Widget build(BuildContext context) {
    return SessionLayout(
      key: globalKey,
      onTap: () {
        // SessionUnitProvider.instance.setBadge(item.id, 555);
        Nav.toChat(context, sessionUnitId: item.id, title: title);
      },
      onLongPress: () {
        Logger().d('onLongPress id:${item.id},dest_id:${dest?.id}');
      },
      avatar: ChatAvatar(id: dest?.id),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
      ),
      subTitle: Text(
        sendTimeDisplay,
        style: const TextStyle(color: Colors.black54, fontSize: 12),
      ),
      child: buildDescription(),
    );
  }

  ///
  Widget buildBadge() {
    return Selector<SessionUnitProvider, int?>(
        selector: ((_, x) => x.getBadge(item.id)),
        builder: (context, value, child) {
          if (value == null || value == 0) {
            return Container();
          }
          if (isImmersed) {
            return Badge();
          }
          return Badge(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            animationType: BadgeAnimationType.fade,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(48),
            badgeContent: Text(
              '$value',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          );
        });
  }

  Widget buildDescription() {
    return SizedBox(
      height: 20,
      child: Expand(
        dir: TextDirection.rtl,
        fixed: Row(
          children: [
            ImmersedIcon(visible: isImmersed),
            buildBadge(),
          ],
        ),
        separated: const SizedBox(width: 8),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
