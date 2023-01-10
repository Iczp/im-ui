import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:im_core/entities.dart';
import 'package:im_core/enums.dart';

import '../../medias.dart';
import '../../nav.dart';
import '../commons/utils.dart';
import '../widgets/expand.dart';

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

  String get title => dest?.name ?? '';

  MessageDto? get lastMessage => item.lastMessage;

  String get subtitle => 'subtitle:$title-getItemInfo(int index)';

  DateTime? get sendTime => lastMessage?.creationTime ?? DateTime.now();

  String get sendTimeDisplay => sendTime != null ? formatTime(sendTime!) : '';

  int get badge => item.badge ?? 0;

  bool get isImmersed => false; //item.isImmersed;

  int get reminderAllCount => item.reminderAllCount ?? 0;

  int get reminderMeCount => item.reminderMeCount ?? 0;

  bool get isRemind => reminderMeCount + reminderAllCount > 0;

  void setBadge(int value) {
    item.badge = badge;
    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: globalKey,
      onTap: () {
        item.badge = item.badge! + 1;
        setBadge(item.badge!);
        Nav.toChat(context, sessionUnitId: item.id);
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Expand(
          fixed: MediaAvatar(
            meidaId: dest?.id ?? '',
            meidaType: MediaTypeEnum.personal,
          ),
          separated: const SizedBox(width: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                child: Expand(
                  dir: TextDirection.rtl,
                  fixed: Text(
                    sendTimeDisplay,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  separated: const SizedBox(width: 8),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                child: Expand(
                  dir: TextDirection.rtl,
                  fixed: Row(
                    children: [
                      const Icon(
                        Icons.notifications_off,
                        size: 16,
                        color: Colors.black26,
                      ),
                      ...buildBadge(),
                    ],
                  ),
                  separated: const SizedBox(width: 8),
                  child: const Text(
                    'subtitleDioMixin.ure >.<',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  List<Widget> buildBadge() {
    if (badge == 0) {
      return <Widget>[];
    }
    return <Widget>[
      const SizedBox(width: 4),
      !isImmersed
          ? Badge(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              shape: BadgeShape.square,
              borderRadius: BorderRadius.circular(48),
              badgeContent: Text(
                '$badge',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            )
          : Badge()
    ];
  }
}
