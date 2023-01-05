import 'package:flutter/material.dart';
import 'package:im_ui/src/sessions/session_list_view.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('session list page'),
      ),
      body: const SessionListView(
        ownerId: 'b700aef5-d48b-4aac-9bbe-52fdcdfd53cb',
      ),
    );
  }
}
