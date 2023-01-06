import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/messages/list_view/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'session_unit_item.dart';

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
  final ScrollPhysics _physics =
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  ///
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ///
  late bool isInited = false;

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
      maxResultCount: 20,
      skipCount: sesssionUnitList.length,
    ).fetch().then((ret) {
      sesssionUnitList = ret.items;
      isInited = true;
      setState(() {});
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  ///
  // @override
  Widget build_refresher(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      header: const WaterDropHeader(),
      child: ListView.builder(
          itemCount: sesssionUnitList.length,
          controller: _controller,
          physics: _physics,
          // itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return SessionUnitItem(
              data: sesssionUnitList[index],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInited) {
      return const Center(
          child: LoadingWidget(
        color: Colors.red,
      ));
    }
    return ListView.builder(
        itemCount: sesssionUnitList.length,
        controller: _controller,
        physics: _physics,
        // itemExtent: 50.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          return SessionUnitItem(
            data: sesssionUnitList[index],
          );
        });
  }
}
