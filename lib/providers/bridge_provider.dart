import 'package:bridge_information/models/pedestrian_bridge.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/bridge.dart';
import '../services/bridge_service.dart';
import '../utils/preferences_util.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：Riverpod
///
//  BridgeService
final bridgeServiceProvider = Provider((ref) => BridgeService());

// 橋樑和人行天橋列表
final bridgeListProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final bridgeService = ref.read(bridgeServiceProvider);
  return bridgeService.fetchBridges();
});

// 分組橋樑和人行天橋
final groupedBridgesProvider =
    StateNotifierProvider<GroupedBridgesNotifier, Map<String, List<dynamic>>>(
        (ref) {
  final bridges = ref.watch(bridgeListProvider).maybeWhen(
        data: (bridges) => bridges,
        orElse: () => {'RoadBridges': [], 'FootBridges': []},
      );
  return GroupedBridgesNotifier(bridges);
});

class GroupedBridgesNotifier extends StateNotifier<Map<String, List<dynamic>>> {
  GroupedBridgesNotifier(Map<String, dynamic> bridges) : super({}) {
    // 分組橋樑和人行天橋資料 20條一組
    groupBridges(
        bridges, (Preferences.prefs.getDouble('sliderValue') ?? 20.0).toInt());
  }

  // 分組橋樑和人行天橋資料並限制每組的數量
  void groupBridges(Map<String, dynamic> bridges, int limit) {
    final Map<String, List<dynamic>> grouped = {};

    // 將橋樑和人行天橋按 AreaCode 分組
    for (var bridge in bridges['RoadBridges']) {
      final code = (bridge as Bridge).AreaCode.toString();
      if (!grouped.containsKey(code)) {
        grouped[code] = [];
      }
      grouped[code]?.add(bridge);
    }

    for (var bridge in bridges['FootBridges']) {
      final code = (bridge as PedestrianBridge).AreaCode.toString();
      if (!grouped.containsKey(code)) {
        grouped[code] = [];
      }
      grouped[code]?.add(bridge);
    }

    final Map<String, List<dynamic>> limitedGrouped = {};
    for (var entry in grouped.entries) {
      final code = entry.key;
      final items = entry.value;

      // 如果某組的數量超過限制，則分割成多個組
      if (items.length > limit) {
        for (int i = 0; i < items.length; i += limit) {
          final subList = items.sublist(
              i, (i + limit) > items.length ? items.length : i + limit);
          final newKey = '$code(${(i ~/ limit) + 1})';
          limitedGrouped[newKey] = subList;
        }
      } else {
        limitedGrouped[code] = items;
      }
    }
    state = limitedGrouped;
  }

  // 更新分組限制
  void updateLimit(Map<String, dynamic> bridges, int limit) {
    groupBridges(bridges, limit);
  }
}
