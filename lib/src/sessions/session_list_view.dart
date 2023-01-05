import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';

class SessionListView extends StatefulWidget {
  ///
  const SessionListView({
    super.key,
    required this.ownerId,
  });

  final String ownerId;
  @override
  State<SessionListView> createState() => _SessionListViewState();
}

class _SessionListViewState extends State<SessionListView> {
  ///
  late List<SessionUnit> sesssionUnitList = <SessionUnit>[];

  /// 滚动监听
  final ScrollController _controller = ScrollController();

  ///滚动物理学
  ScrollPhysics? _physics =
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  ///
  @override
  void initState() {
    super.initState();
    fetchData();
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      if (kDebugMode) {
        // print(_controller.offset);
      } //打印滚动位置
    });
  }

  double getMaxAutoId() {
    return 0;
  }

  ///
  void fetchData() {
    SessionUnitGetList(
      ownerId: widget.ownerId,
      maxResultCount: 30,
      skipCount: sesssionUnitList.length,
    ).fetch().then((ret) {
      sesssionUnitList = ret.items;
      setState(() {});
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sesssionUnitList.length,
        controller: _controller,
        physics: _physics,
        // itemExtent: 50.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          var sessionUnit = sesssionUnitList[index];
          return ListTile(
            title: Text('$index:${sessionUnit.destination?.name}'),
          );
        });
  }
}
