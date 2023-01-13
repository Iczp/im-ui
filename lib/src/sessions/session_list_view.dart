import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:im_core/im_core.dart';
import 'package:im_ui/src/messages/list_view/loading_widget.dart';
import 'package:im_ui/src/providers/chat_object_provider.dart';
import 'package:im_ui/src/providers/session_unit_provider.dart';
import 'package:logger/logger.dart';
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
  final ScrollController scrollController = ScrollController();

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

    sesssionUnitList = SessionUnitProvider.instance.getList();
    setState(() {});
    fetchData();

    scrollController.addListener(_scrollHander);
  }

  double getMaxAutoId() {
    return 0;
  }

  void _scrollHander() {
    //监听滚动事件，打印滚动位置
    if (kDebugMode) {
      // print(_controller.offset);
    }
    var pixels = scrollController.position.pixels;
    if (pixels < scrollController.position.minScrollExtent - 50) {
      // Logger().d(':up:$pixels');
      _headerHander();
    } else if (pixels > scrollController.position.maxScrollExtent + 50) {
      _footerHander();
      // Logger().d(':down:${pixels - scrollController.position.maxScrollExtent}');
    }
  }

  late bool isHeaderHanded = false;
  void _headerHander() {
    if (isHeaderHanded) {
      return;
    }
    Logger().w('_headerHander');
    isHeaderHanded = true;
    // SessionUnitProvider.instance
    //     .fetchNewSession()
    //     .then((value) => isHeaderHanded = false);
  }

  void _footerHander() {
    Logger().d('_footerHander');
  }

  ///
  void fetchData() {
    SessionUnitGetList(
      ownerId: widget.ownerId,
      maxResultCount: 100,
      skipCount: sesssionUnitList.length,
    ).submit().then((_) {
      SessionUnitProvider.instance.setMany(_.items);
      ChatObjectProvider.instance.setMany(_.items
          .where((x) => x.destination != null)
          .map((e) => e.destination!)
          .toList());
      isInited = true;
      sesssionUnitList = SessionUnitProvider.instance.getList();
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
          controller: scrollController,
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
    if (!isInited && sesssionUnitList.isEmpty) {
      return const Center(
          child: LoadingWidget(
        color: Colors.red,
      ));
    }
    return Listener(
      onPointerCancel: (event) {
        Logger().d('onPointerCancel');
      },
      onPointerDown: (event) {
        Logger().d('onPointerDown');
      },
      onPointerUp: (event) {
        Logger().d('onPointerUp');
        var pixels = scrollController.position.pixels;
        if (pixels < scrollController.position.minScrollExtent - 50) {
          Logger().d('onPointerUp:refresh()');
          SessionUnitProvider.instance.fetchNewSession().then((value) => null);
        }
      },
      onPointerMove: (event) {
        // Logger().d('onPointerMove');
      },
      child: ListView.builder(
          itemCount: sesssionUnitList.length,
          controller: scrollController,
          physics: _physics,
          // itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return SessionUnitItem(
              data: sesssionUnitList[index],
            );
          }),
    );
  }
}
