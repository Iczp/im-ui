import 'package:flutter/material.dart';
import 'package:im_ui/providers.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        title: Text('消息-${ChatObjectProvider.instance.currentId}'),
      ),
      body: SessionListView(
        ownerId: ChatObjectProvider.instance.currentId,
      ),
    );
  }
}
