import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'buttons/message_menu_button.dart';
import '../widgets/mask.dart';

///消息右键菜单
class MessageMenuDialog extends StatefulWidget {
  ///
  static String caller = 'MessageMenuDialog';

  ///
  const MessageMenuDialog({
    Key? key,
    this.layerLink,
    this.sourceKey,
    // this.onMenuTap,
    this.rowCount = 5,
    this.spacing = 5,
    this.padding = 5,
    this.itemWidth = 40.0,
    this.offsetY = 150.0,
    this.color = const Color.fromARGB(225, 0, 0, 0),
  }) : super(key: key);

  ///
  final double padding;

  ///
  final double offsetY;

  ///
  final Color color;

  ///
  final GlobalKey? sourceKey;

  ///
  final LayerLink? layerLink;

  /// 间隔
  final double spacing;

  /// 每行个数
  final int rowCount;

  /// 单个宽度
  final double itemWidth;

  // ///
  // final MenuItemTapCallback? onMenuTap;

  ///
  @override
  State<MessageMenuDialog> createState() => MessageMenuDialogState();
}

class MessageMenuDialogState extends State<MessageMenuDialog> {
  List<MessageMenuButton> _menus = [];
  GlobalKey<MaskState> maskKey = GlobalKey();
  bool _isDisplay = false;
  double? _left;
  double? _right;
  double? _bottom;
  double? _top;

  ///
  EdgeInsets? _arrowMargin;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;
  bool isOutsided = false;

  ///
  double _rowWidth = 50;

  ///
  double _getRowWidth(int count) {
    int rowCount = count >= widget.rowCount ? widget.rowCount : count;
    return widget.itemWidth * rowCount +
        widget.padding * 2 +
        widget.spacing * (rowCount - 1);
  }

  // ///
  // void _onMenuTap(MediaMenuItem menuItem) {
  //   setState(() {
  //     widget.onMenuTap?.call(menuItem);
  //     close();
  //   });
  // }

  /// 菜单项
  List<Widget> _buildMenus() {
    return _menus;
    // return [
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.forward,
    //     text: '转发',
    //     code: MenuTypeEnum.forward,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.copy,
    //     text: '复制',
    //     code: MenuTypeEnum.copy,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.format_quote_sharp,
    //     text: '引用',
    //     code: MenuTypeEnum.quote,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.bookmark_add,
    //     text: '收藏',
    //     code: MenuTypeEnum.headPhones,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.play_circle_fill_sharp,
    //     text: '播放',
    //     code: MenuTypeEnum.soundPlay,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.headphones,
    //     text: '听筒',
    //     code: MenuTypeEnum.headPhones,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.notifications,
    //     text: '提醒',
    //     code: MenuTypeEnum.reminder,
    //     onTap: _onMenuTap,
    //   ),
    //   MediaMenuItem(
    //     direction: Axis.vertical,
    //     iconData: Icons.checklist_rtl_sharp,
    //     text: '多选',
    //     code: MenuTypeEnum.multipleChoice,
    //     onTap: _onMenuTap,
    //   ),
    // ];
  }

  ///气泡（箭头）
  Widget _arrowBubble({
    EdgeInsetsGeometry? margin,
    double size = 10,
    bool isBottom = false,
  }) {
    var borderSide =
        BorderSide(color: widget.color, width: size, style: BorderStyle.solid);

    return Container(
      margin: margin,
      width: 20,
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        // color: Color.fromARGB(125, 0, 0, 0),
        border: Border(
          // 四个值 top right bottom left
          top: !isBottom ? BorderSide.none : borderSide,
          bottom: isBottom ? BorderSide.none : borderSide,
          right: BorderSide(
              color: Colors.transparent, width: size, style: BorderStyle.solid),
          left: BorderSide(
              color: Colors.transparent, width: size, style: BorderStyle.solid),
        ),
      ),
    );
  }

  ///
  void _setPosition(GlobalKey sourceKey) {
    Logger().i(
        '_setPosition sourceKey:$sourceKey ,currentWidget:${sourceKey.currentWidget},currentContext:${sourceKey.currentContext}');

    maskKey.currentState?.show(toString());
    // GlobalKey globalKey = widget.sourceKey!;
    //获取`RenderBox`对象
    RenderBox renderBox =
        sourceKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(const Offset(0, 0));
    debugPrint("----------positions of red:$offset");
    final size = renderBox.size;
    debugPrint("----------size of red:$size");

    ///=============== left and right ===============
    _left = offset.dx + size.width / 2 - _rowWidth / 2;
    _right = null;

    _arrowMargin = const EdgeInsets.only(
      bottom: 2,
    );
    const double messageItemMargin = 8;
    _crossAxisAlignment = CrossAxisAlignment.center;
    var arrowMarginValue = 48 + messageItemMargin + size.width / 2 - 20;
    if (_left! + _rowWidth >
        MediaQuery.of(context).size.width - messageItemMargin) {
      _left = null;
      _right = messageItemMargin;
      _arrowMargin = EdgeInsets.only(
        right: arrowMarginValue,
      );
      _crossAxisAlignment = CrossAxisAlignment.end;
    } else if (_left! < messageItemMargin) {
      _left = 8;
      _right = null;
      _arrowMargin = EdgeInsets.only(
        left: arrowMarginValue,
      );
      _crossAxisAlignment = CrossAxisAlignment.start;
    }

    ///=============== top and bottom ===============
    _bottom = MediaQuery.of(context).size.height - offset.dy;
    _top = null;

    isOutsided = offset.dy < widget.offsetY;
    if (isOutsided) {
      _top = offset.dy + size.height;
      _bottom = null;
    }
    _isDisplay = true;
  }

  ///
  void _setMenus(List<MessageMenuButton> menus) {
    _menus = menus;
    _rowWidth = _getRowWidth(menus.length);
  }

  /// show
  void open(GlobalKey sourceKey, List<MessageMenuButton> menus) {
    if (sourceKey.currentContext == null || sourceKey.currentWidget == null) {
      return;
    }

    _setMenus(menus);
    _setPosition(sourceKey);
    setState(() {});
  }

  ///
  void close() {
    _isDisplay = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Logger().d(
    //     'MessageMenuDialog isDisplay:${widget.isDisplay},${widget.messageSourceKey == null}');

    // Logger().i(
    //     'currentWidget:${widget.sourceKey?.currentWidget},sourceKey:${widget.sourceKey},currentContext:${widget.sourceKey?.currentContext}');

    ///
    // return const SizedBox();
    if (!_isDisplay) {
      // Logger().d('1.====${!widget.isDisplay}');
      // Logger().d('2.====${widget.messageSourceKey == null}');
      // Logger().d('3.====${widget.messageSourceKey?.currentContext == null}');
      return const SizedBox();
    }

    Logger().d('left:$_left,right:$_right,bottom:$_bottom,top:$_top');

    return Mask(
      caller: 'ddd',
      key: maskKey,
      // color: Color.fromARGB(132, 244, 67, 54),
      onClose: close,
      child: Positioned(
        left: _left,
        right: _right,
        bottom: _bottom,
        top: _top,
        child: CompositedTransformFollower(
          link: widget.layerLink ?? LayerLink(),
          followerAnchor: Alignment.bottomCenter,
          child: SizedBox(
            // height: 200,
            // width: 200,
            // margin: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              verticalDirection:
                  isOutsided ? VerticalDirection.up : VerticalDirection.down,
              crossAxisAlignment: _crossAxisAlignment,
              children: [
                Container(
                  // width: widget.maxWidth,
                  constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: _rowWidth,
                  ),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(widget.padding),
                  child: Wrap(
                    spacing: widget.spacing,
                    runSpacing: widget.spacing,
                    direction: Axis.horizontal,
                    children: _buildMenus(),
                  ),
                ),
                _arrowBubble(
                  isBottom: !isOutsided,
                  margin: _arrowMargin,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
