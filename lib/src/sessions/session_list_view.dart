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
  final ScrollPhysics scrollPhysics =
      const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

  ///
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ///
  late bool isInited = false;

  final GlobalKey<LoadingWidgetState> footerLoading = GlobalKey();
  final GlobalKey<LoadingWidgetState> headerLoading = GlobalKey();

  ///
  @override
  initState() {
    super.initState();

    sesssionUnitList = SessionUnitProvider.instance.getList();
    setState(() {});
    fetchNew();
    fetchMore();
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
      fetchMore();
      // Logger().d(':down:${pixels - scrollController.position.maxScrollExtent}');
    }
  }

  late bool isHeaderHanded = false;
  late bool isFooterHanded = false;
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

  void fetchMore() {
    if (footerLoading.currentState?.visible ?? false) {
      return;
    }
    Logger().d('footerLoading');
    footerLoading.currentState?.show();
    SessionUnitProvider.instance
        .fetchMore(ownerId: widget.ownerId)
        .whenComplete(() => footerLoading.currentState?.hide());
  }

  void fetchNew() {
    if (headerLoading.currentState?.visible ?? false) {
      return;
    }
    Logger().d('headerLoading');
    headerLoading.currentState?.show();
    SessionUnitProvider.instance
        .fetchNew(ownerId: widget.ownerId)
        .whenComplete(() => headerLoading.currentState?.hide());

    SessionUnitProvider.instance
        .fetchNew(ownerId: ChatObjectProvider.instance.currentId);
  }

  ///
  Future<void> fetchData() async {
    var ret = await SessionUnitGetList(
      ownerId: widget.ownerId,
      isTopping: false,
      maxResultCount: 100,
      skipCount: sesssionUnitList.length,
    ).submit();
    SessionUnitProvider.instance.setMany(ret.items);
    ChatObjectProvider.instance.setMany(ret.items
        .where((x) => x.destination != null)
        .map((e) => e.destination!)
        .toList());
    isInited = true;
    sesssionUnitList = SessionUnitProvider.instance.getList();
    // sesssionUnitList.addAll(ret.items);
    setState(() {});
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
        // Logger().d('onPointerDown');
      },
      onPointerUp: (event) {
        // Logger().d('onPointerUp');
        var pixels = scrollController.position.pixels;
        if (pixels < scrollController.position.minScrollExtent - 50) {
          Logger().d('onPointerUp:refresh()');
          fetchNew();
        }
      },
      onPointerMove: (event) {
        // Logger().d('onPointerMove:${event.distance} - ${event}');
      },
      child: ReorderableListView.builder(
        itemCount: sesssionUnitList.length,
        scrollController: scrollController,
        physics: scrollPhysics,
        buildDefaultDragHandles: false,
        // itemExtent: 50.0, //强制高度为50.0
        itemBuilder: (BuildContext context, int index) {
          return SessionUnitItem(
            key: Key(sesssionUnitList[index].globalKey.toString()),
            data: sesssionUnitList[index],
          );
        },

        onReorder: (int oldIndex, int newIndex) {},
        header: LoadingWidget(key: headerLoading),
        footer: LoadingWidget(key: footerLoading),
      ),
    );
  }
}
