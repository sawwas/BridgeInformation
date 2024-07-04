import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../pages/detail_page.dart';
import '../../pages/home_page.dart';
import 'app_route_path_util.dart';
import 'app_state.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：路由委託
///
class AppRouterDelegate extends RouterDelegate<AppRoutePathUtil>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePathUtil> {
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  AppRouterDelegate(this.appState)
      : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  AppRoutePathUtil get currentConfiguration => appState.routePath;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      // 路由管理 - 路由推送
      pages: pageRoutePushManage(),
      onPopPage: (route, result) {
        // 路由管理 - 路由彈出
        return pageRoutePopManage(route, result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePathUtil path) async {
    // 路由管理 - 選擇路由
    selectRoutePath(path);
  }
}
