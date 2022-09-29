import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/chating_page.dart';
import 'package:im_ui/im_ui.dart';
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    // return ChatPage();
                    return const ChatingPage(
                      title: 'title',
                      // scrollMode: index % 2,
                      media: MediaInput.build('china', MediaTypeEnum.personal),
                    );
                  },
                ),
              );
            },
            child: const Text('chat-page'),
          )
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
