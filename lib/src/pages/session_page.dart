import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/providers.dart';
import 'package:im_ui/src/avatars/chat_avatar.dart';
import 'package:im_ui/src/avatars/chat_name.dart';
import 'package:im_ui/src/pages/session_change_page.dart';
import 'package:im_ui/src/routes/pop_route.dart';
import 'package:im_ui/src/sessions/session_list_view.dart';
import 'package:logger/logger.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  get builder => null;

  ChatObjectProvider get chatObjectProvider => ChatObjectProvider.singleton;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ChatObjectGetMany(idList: [
      chatObjectProvider.currentId,
    ]).submit().then((list) => chatObjectProvider.setMany(list));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Logger().w("lifeChanged $state");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(context, PopRoute(child: const SessionChangePage()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ChatAvatar(
                  id: chatObjectProvider.currentId,
                  size: 24,
                ),
                ChatName(
                  id: chatObjectProvider.currentId,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  size: 14,
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ),
      ),
      body: SessionListView(
        ownerId: chatObjectProvider.currentId,
      ),
    );
  }
}
