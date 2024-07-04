import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_route_path_util.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：應用路由狀態管理
///
class AppState extends ChangeNotifier {
  AppRoutePathUtil _routePath = AppRoutePathUtil.home();

  AppRoutePathUtil get routePath => _routePath;

  void showHomePage() {
    _routePath = AppRoutePathUtil.home();
    notifyListeners();
  }

  void showDetailsPage(Map<String, dynamic> data) {
    _routePath = AppRoutePathUtil.details(data);
    notifyListeners();
  }
}
