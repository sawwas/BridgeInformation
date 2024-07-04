import 'package:flutter/cupertino.dart';

import 'app_route_path_util.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：路由資訊解析器
class AppRouteInformationParser
    extends RouteInformationParser<AppRoutePathUtil> {
  @override
  Future<AppRoutePathUtil> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return AppRoutePathUtil.home();
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'details') {
      final id = uri.pathSegments[1];
      return AppRoutePathUtil.details({'id': id});
    }

    return AppRoutePathUtil.home();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePathUtil path) {
    if (path.data[Routes.ROUTE_KEY] == Routes.PUSH_HOME_PAGE) {
      return RouteInformation(uri: Uri.parse('/'));
    }
    if (path.data[Routes.ROUTE_KEY] == Routes.PUSH_DETAIL_PAGE) {
      return RouteInformation(uri: Uri.parse('/details/${path.data?['id']}'));
    }
    return null;
  }
}
