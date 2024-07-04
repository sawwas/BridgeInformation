import 'package:bridge_information/pages/home_page.dart';
import 'package:bridge_information/providers/router/app_route_information_parser.dart';
import 'package:bridge_information/providers/router/app_router_delegate.dart';
import 'package:bridge_information/providers/router/app_state.dart';
import 'package:bridge_information/services/bridge_service.dart';
import 'package:bridge_information/utils/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // 初始化shared_preferences，並取得橋樑｜人行陸橋資料保存到SQLite
  await initializeApp();

  FlutterNativeSplash.remove();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'zh_Hant'],
  );

  runApp(LocalizedApp(delegate, const ProviderScope(child: MyApp())));
}

// 新安裝app時，初始化shared_preferences，並取得橋樑｜人行陸橋資料保存到SQLite
Future<void> initializeApp() async {
  BridgeService bridgeService = BridgeService();
  await bridgeService.fetchBridges();
  Future.wait([Preferences().init(), bridgeService.fetchBridges()]);
}

// 應用路由狀態管理
final AppState appState = AppState();
AppRouterDelegate appRouterDelegate = AppRouterDelegate(appState);
AppRouteInformationParser appRouteInformationParser =
    AppRouteInformationParser();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp.router(
          title: translate('app_name'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerDelegate: appRouterDelegate,
          routeInformationParser: appRouteInformationParser,
          localizationsDelegates: [
            localizationDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
        ),
      ),
    );
  }
}
