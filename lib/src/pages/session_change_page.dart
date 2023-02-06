import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/avatars/chat_avatar.dart';
import 'package:im_ui/src/avatars/chat_name.dart';
import 'package:im_ui/src/providers/chat_object_provider.dart';

class SessionChangePage extends StatefulWidget {
  const SessionChangePage({super.key});

  @override
  State<SessionChangePage> createState() => _SessionChangePageState();
}

class _SessionChangePageState extends State<SessionChangePage> {
  ///
  ChatObjectProvider get chatObjectProvider => ChatObjectProvider.instance;

  late List<ChatObject> list = <ChatObject>[
    ChatObject(id: chatObjectProvider.currentId),
    ChatObject(id: '696aa1f2-e2dc-4d92-a4b0-dc2cbe4d0054'),
  ];

  bool isCurrent(String chatObjectId) =>
      chatObjectId == chatObjectProvider.currentId;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black12,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Positioned.fill(
            top: 80,
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              //  width: 100,
              // height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),

              child: ListView.separated(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: buildItems(index),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 0.25,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  buildItems(int index) {
    var chatObject = list[index];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          chatObjectProvider.setCurrent(chatObject.id);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          color: Colors.white70,
          height: 48,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              ChatAvatar(
                id: chatObject.id,
                size: 32,
              ),
              ChatName(
                id: chatObject.id,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                size: 16,
                // color: Colors.white,
              ),
              if (isCurrent(chatObject.id))
                const Icon(
                  Icons.check,
                  // color: Colors.white,
                  size: 16,
                )
            ],
          ),
        ),
      ),
    );
  }
}
