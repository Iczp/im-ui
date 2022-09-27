import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:im_core/im_core.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
class UsersProvide with ChangeNotifier, DiagnosticableTreeMixin {
  ///
  UsersProvide() {
    initData();
  }

  ///
  static final _instance = UsersProvide();

  ///
  static UsersProvide get instance => _instance;

  ///登录用户 id(dev)
  String? _loginUserId;

  // int _count = 0;

  // void addCount() {
  //   _count++;
  //   notifyListeners();
  // }

  // int get count => _count;

  /// users
  final Map<String, AppUserDto> _users = <String, AppUserDto>{};

  static const data = [
    ['zhongpei', 'zhongpei'],
    ['zhuwei', 'zhuwei'],
    ['wangqilian', 'wangqilian'],
    ['wanglifeng', 'wanglifeng'],
    ['china', 'china'],
    ['flutter', 'flutter'],
  ];
  // ignore: non_constant_identifier_names
  AsyncInitialize() {
    log('AsyncInitialize');
    _loadAsyncThing();
  }

  Future<void> _loadAsyncThing() async {
    // data.map((e) {
    //   log('_loadAsyncThing：$e');
    //   setUser(AppUserDto(
    //     id: e[0],
    //     account: e[0],
    //     name: e[1],
    //     nick: e[1],
    //   ));
    // });
    notifyListeners();
  }

  static const imgs = [
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
    'http://www.rctea.com/uploadFiles/product/300/320x320/8647b328.png',
    'http://www.rctea.com/uploadFiles/product/439/320x320/1dc87fa4.jpg',
    'http://www.rctea.com/uploadFiles/newsFiles/2022/2022-8/4fb98bb3.jpg',
    'http://www.rctea.com/uploadFiles/product/164/320x320/2f877c44.jpg',
    'http://www.rctea.com/uploadFiles/product/475/320x320/159fff1e.jpg',
  ];
  void initData() {
    log('initData');

    for (var i = 0; i < data.length; i++) {
      var e = data[i];
      setUser(
        AppUserDto(
          id: e[0],
          account: e[0],
          name: e[1],
          nick: e[1],
          portrait: imgs[i % (imgs.length)],
        ),
      );
    }

    notifyListeners();
  }

  bool isLogin() {
    return _loginUserId != null;
  }

  ///登录用户Id
  String? get loginUserId => _loginUserId;

  /// 用户集合
  Map<String, AppUserDto> get users => _users;

  ///当前登录用户
  AppUserDto? get currentUser => isLogin() ? getById(_loginUserId!) : null;

  /// getById
  AppUserDto? getById(String id) => _users[id];

  void setUser(AppUserDto user) {
    _users[user.id] = user;
    notifyListeners();
  }

  void setLoginUser(AppUserDto loginUser) {
    _loginUserId = loginUser.id;
    setUser(loginUser);
  }

  List<AppUserDto> getUserList() {
    var userList = <AppUserDto>[];
    _users.forEach((key, user) {
      userList.add(user);
    });
    return userList;
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Map<String, AppUserDto>>('users', _users));
  }
}
