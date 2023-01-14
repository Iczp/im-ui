import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/pages.dart';
import 'package:im_ui/im_ui.dart';
import 'package:im_ui/commons.dart';
import 'package:im_ui/providers.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ImUi.initialized();
  UsersProvide.instance.setLoginUser(AppUserDto(
    id: 'zhongpei',
    account: 'zhongpei',
    name: '陈忠培**',
  ));
  runApp(
    MultiProvider(
      providers: [
        ...ImUi.providies,
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ImUi.globalKey,
      title: 'im ui Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'im ui Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int badge = 0;

  int _counter = 0;

  ///
  void fetchBadge() {
    SessionUnitGetBadge(ownerId: ChatObjectProvider.instance.currentId)
        .submit()
        .then((count) {
      badge = count;
      setState(() {});
    });

    SessionUnitGetList(
      ownerId: ChatObjectProvider.instance.currentId,
      isTopping: true,
      maxResultCount: 100,
    ).submit().then((_) {
      SessionUnitProvider.instance.setMany(_.items);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBadge();
  }

  void _incrementCounter() {
    badge = 0;
    _counter++;
    setState(() {});
    fetchBadge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Nav.toChat(context, sessionUnitId: 'ddddd');
            },
            child: const Text('chat-page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    // return ChatPage();
                    return const SessionPage();
                  },
                ),
              );
            },
            child: Text('session list view($badge)'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
