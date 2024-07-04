//
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../pages/detail_page.dart';
import '../../pages/home_page.dart';
import '../home_page_state.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：定義路由工具類
///
class Routes {
  static const String ROUTE_KEY = 'ROUTE'; // 路由鍵
  static const String PUSH_HOME_PAGE = 'HOME_PAGE'; // 首頁
  static const String PUSH_DETAIL_PAGE = 'DETAIL_PAGE'; // 詳情頁
}

class AppRoutePathUtil {
  Map<String, dynamic> data = {Routes.ROUTE_KEY: Routes.PUSH_HOME_PAGE};

  AppRoutePathUtil.home() : data = {Routes.ROUTE_KEY: Routes.PUSH_HOME_PAGE};

  AppRoutePathUtil.details(Map<String, dynamic> data)
      : data = {Routes.ROUTE_KEY: Routes.PUSH_DETAIL_PAGE, ...data};
}

// 路由管理 - 選擇路由
selectRoutePath(AppRoutePathUtil path) {
  switch (path.data[Routes.ROUTE_KEY]) {
    case Routes.PUSH_HOME_PAGE:
      appState.showHomePage();
      break;
    case Routes.PUSH_DETAIL_PAGE:
      appState.showDetailsPage({'id': path.data});
      break;
  }
}

// 路由管理 - 路由推送
Function currentPath = () => appState.routePath.data[Routes.ROUTE_KEY];

// 首頁狀態
final HomePageState homePageState = HomePageState();

List<Page<dynamic>> pageRoutePushManage() => [
      MaterialPage(
          child: HomePage(
              onDetailsSelected: (data) {
                appState.showDetailsPage(data);
              },
              state: homePageState)),
      if (currentPath() == Routes.PUSH_DETAIL_PAGE)
        MaterialPage(
          child: DetailPage(data: appState.routePath.data),
        )
    ];

// 路由管理 - 路由彈出
bool pageRoutePopManage(Route<dynamic> route, dynamic result) {
  if (!route.didPop(result)) {
    return false;
  }

  if (appState.routePath.data[Routes.ROUTE_KEY] == Routes.PUSH_DETAIL_PAGE) {
    appState.showHomePage();
  }
  return true;
}
