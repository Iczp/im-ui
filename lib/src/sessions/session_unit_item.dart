import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:im_core/entities.dart';
import 'package:im_ui/src/avatars/chat_avatar.dart';
import 'package:im_ui/src/avatars/chat_name.dart';
import 'package:im_ui/src/providers/session_unit_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../commons/nav.dart';
import '../commons/utils.dart';
import '../widgets/expand.dart';
import '../widgets/immersed_icon.dart';
import '../widgets/session_layout.dart';
import 'session_immersed.dart';

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

  MessageDto? get message => item.lastMessage;

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
        Logger().d('onLongPress id:${item.toJson()}');
      },
      avatar: ChatAvatar(id: dest?.id),
      title: buildChatName(),
      side: buildSendTime(),
      child: buildDescription(),
    );
  }

  ///
  Widget buildBadge() {
    return Selector<SessionUnitProvider, SessionUnit?>(
        selector: ((_, x) => x.get(item.id)),
        builder: (context, entity, child) {
          if (entity?.badge == null || entity!.badge == 0) {
            return Container();
          }

          if (entity.isImmersed) {
            return Badge();
          }

          return Badge(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            animationType: BadgeAnimationType.fade,
            shape: BadgeShape.square,
            borderRadius: BorderRadius.circular(48),
            badgeContent: Text(
              '${entity.badge}',
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
            SessionImmersed(sessionUnitId: item.id),
            buildBadge(),
          ],
        ),
        separated: const SizedBox(width: 8),
        child: buildMessageThumb(),
      ),
    );
  }

  Widget buildSendTime() {
    return Selector<SessionUnitProvider, DateTime?>(
      selector: ((_, x) => x.getSendTime(item.id)),
      builder: (_, value, child) {
        return Text(
          value != null ? formatTime(value) : '',
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        );
      },
    );
  }

  Widget buildChatName() {
    if (item.rename == null) {
      return ChatName(id: dest?.id);
    }

    return Selector<SessionUnitProvider, String>(
      selector: ((_, x) => x.getRename(item.id) ?? ''),
      builder: (_, value, child) {
        return Text(
          value,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        );
      },
    );
  }

  Widget buildMessageThumb() {
    return Selector<SessionUnitProvider, MessageDto?>(
      selector: ((_, x) => x.getLastMessage(item.id)),
      builder: (_, message, child) {
        if (message == null) {
          return Container();
        }
        return Text(
          '${message.content}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
