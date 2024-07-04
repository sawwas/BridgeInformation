import 'package:flutter/cupertino.dart';

import '../../main.dart';

// 頂部安全距離
final double topPadding =
    MediaQuery.of(appRouterDelegate.navigatorKey.currentState!.context)
        .padding
        .top;

// 底部安全距離
final double bottomPadding =
    MediaQuery.of(appRouterDelegate.navigatorKey.currentState!.context)
        .padding
        .bottom;
