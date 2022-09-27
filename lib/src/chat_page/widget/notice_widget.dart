import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

///消息通知组件
class NoticeWidget extends StatefulWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          // side: BorderSide(
          //   color: Theme.of(context).colorScheme.outline,
          // ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          splashColor: const Color.fromARGB(255, 33, 243, 82).withAlpha(30),
          onTap: () {
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //       builder: (context) => const NoticeDetailPage(
            //         id: '123465789',
            //         title: '消息',
            //       ),
            //     ));
          },
          child: ListTile(
            // isThreeLine: true,
            // contentPadding: EdgeInsets.all(8),
            selected: false,
            leading: const Icon(
              Icons.notifications_active_rounded,
              size: 36,
              color: Color.fromARGB(255, 231, 54, 0),
            ),
            title: const Text('你 1 条 新消息'),
            subtitle: const Text(
              '子组件若需要监听键盘高度，需设置为false',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Badge(
              shape: BadgeShape.square,
              borderRadius: BorderRadius.circular(24),
              // position: BadgePosition.topEnd(top: 10, end: 10),
              badgeContent: const Text(
                '106',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
