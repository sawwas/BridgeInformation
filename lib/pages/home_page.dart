import 'dart:io';

import 'package:bridge_information/models/bridge.dart';
import 'package:bridge_information/models/pedestrian_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../main.dart';
import '../providers/bridge_provider.dart';
import '../providers/home_page_state.dart';
import '../services/bridge_service.dart';
import '../utils/custom_division_slider_thumb_shape.dart';
import '../utils/preferences_util.dart';
import '../utils/widgets/safe_screen_util.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：台北市橋樑及人行陸橋資訊頁面
class HomePage extends StatelessWidget {
  final void Function(Map<String, dynamic> data) onDetailsSelected;
  final HomePageState state;

  const HomePage(
      {super.key, required this.onDetailsSelected, required this.state});

  @override
  Widget build(BuildContext context) {
    return HomeInherited(
      onDetailsSelected: onDetailsSelected,
      state: state,
      child: HomeListWidget(),
    );
  }
}

class HomeInherited extends InheritedWidget {
  final void Function(Map<String, dynamic> data) onDetailsSelected;
  final HomePageState state;

  const HomeInherited(
      {super.key,
      required this.onDetailsSelected,
      required this.state,
      required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static HomeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeInherited>()!;
  }
}

// 用戶操作紀錄
// Map<String, bool> expandedTemp = {};

class HomeListWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 獲取橋樑和人行天橋列表
    final bridgeListAsyncValue = ref.watch(bridgeListProvider);
    // 分組橋樑和人行天橋
    final groupedBridges = ref.watch(groupedBridgesProvider);
    // 組數值：默認20條一組
    final sliderValue =
        useState(Preferences.prefs.getDouble('sliderValue') ?? 20.0);
    // 管理每個item項目是否展開
    final _expandedTiles = useState<Map<String, bool>>(
        HomeInherited.of(context).state.expandedTemp);
    bool isExpandedColor(key) {
      return _expandedTiles.value[key] == true;
    }

    // 滾動控制器
    final _scrollController = useScrollController(
        initialScrollOffset: HomeInherited.of(context).state.scrollPosition);

    useEffect(() {
      // 移除啟動頁面
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          FlutterNativeSplash.remove();
        });
      });

      _scrollController.addListener(() {
        // 保存滾動位置
        HomeInherited.of(context).state.scrollPosition =
            _scrollController.position.pixels;
      });
      return null;
    }, []);

    // 是否展開item項目 文字樣式
    isExpandedTextStyle(key) => TextStyle(
        color: isExpandedColor(key) ? Colors.black : Colors.white,
        shadows: isExpandedColor(key)
            ? [
                Shadow(
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 10.0,
                  color: isExpandedColor(key)
                      ? Colors.white.withOpacity(0.6)
                      : Colors.white,
                ),
              ]
            : []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 背景圖片
          placeBG(),
          bridgeListAsyncValue.when(
            data: (bridges) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: topPadding + 10.h, bottom: 10.h),
                  child: Text(
                    translate('app_name'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: groupedBridges.length,
                    padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                    itemBuilder: (context, index) {
                      final key = groupedBridges.keys.elementAt(index);
                      final bridges = groupedBridges[key]!;

                      // 預先計算索引，以減少在 itemBuilder 中的計算
                      final bridgeWidgets =
                          bridges.asMap().entries.map((entry) {
                        final bridge = entry.value;
                        final idx = entry.key;
                        if (bridge is Bridge) {
                          return GestureDetector(
                            onTap: () {
                              // 跳轉到詳情頁面
                              HomeInherited.of(context)
                                  .onDetailsSelected({'bridge_data': bridge});
                            },
                            child: ListTile(
                              key: ValueKey("Bridge_${bridge.AreaCode}_$idx"),
                              title: Text(bridge.bridgeName,
                                  style: isExpandedTextStyle(key)),
                              trailing: Text(
                                '【${idx + 1}】',
                                style: isExpandedTextStyle(key),
                              ),
                            ),
                          );
                        } else if (bridge is PedestrianBridge) {
                          return GestureDetector(
                            onTap: () {
                              // 跳轉到詳情頁面
                              HomeInherited.of(context)
                                  .onDetailsSelected({'bridge_data': bridge});
                            },
                            child: ListTile(
                              key: ValueKey(
                                  "PedestrianBridge_${bridge.AreaCode}_$idx"),
                              title: Text(
                                bridge.footbridgeName,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              trailing: Text(
                                '【${idx + 1}】',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black87),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList();

                      return Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                            key: ValueKey(key),
                            title: Text(
                              '${translate('group_no')}\n${key}',
                              style: isExpandedTextStyle(key),
                            ),
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.black87,
                            children: bridgeWidgets,
                            onExpansionChanged: (isExpanded) {
                              // 是否展開item項
                              HomeInherited.of(context).state.expandedTemp = {
                                ..._expandedTiles.value
                              };
                              HomeInherited.of(context)
                                  .state
                                  .expandedTemp[key] = isExpanded;
                              _expandedTiles.value =
                                  HomeInherited.of(context).state.expandedTemp;
                            },
                            initiallyExpanded: isExpandedColor(key),
                            visualDensity: const VisualDensity(
                              horizontal: -2,
                              vertical: 2,
                            )),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: bottomPadding + (Platform.isAndroid ? 16.h : 0),
                      top: 30.h),
                  child: SliderTheme(
                    data: SliderThemeData(
                        thumbColor: Colors.transparent,
                        thumbShape: CustomDivisionSliderThumbShape(
                            showValueIndicator: true,
                            pre:
                                '${translate('group_limit')}  ${double.parse('${sliderValue.value}').toStringAsFixed(0)}'),
                        inactiveTrackColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                        trackHeight: 24.0,
                        tickMarkShape:
                            CustomTickMarkShape(isEnableDivision: true),
                        trackShape: GradientRectSliderTrackShape(
                            isEnableDivision: true)),
                    child: Slider(
                      value: sliderValue.value,
                      min: 1,
                      max: 20,
                      divisions: 19,
                      onChanged: (value) {
                        // 更新 sliderValue 的值
                        sliderValue.value = value;

                        // 更新分組橋樑和人行天橋資料 按照新的 limit
                        ref
                            .read(groupedBridgesProvider.notifier)
                            .updateLimit(bridges, value.toInt());

                        // 保存 sliderValue 的值
                        Preferences.prefs.setDouble('sliderValue', value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            loading: () => SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  JumpingText(
                    translate('data_init'),
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  SizedBox(height: 35.h),
                ],
              ),
            ),
            error: (error, stack) =>
                Center(child: Text('Failed to load data: $error')),
          ),
        ],
      ),
    );
  }
}

// 背景圖片
Widget placeBG() {
  return Positioned.fill(
    child: Image.asset(
      'assets/bridge_icon.jpg',
      fit: BoxFit.fill,
    ),
  );
}
