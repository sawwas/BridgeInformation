import 'dart:convert';
import 'package:bridge_information/models/pedestrian_bridge.dart';
import 'package:bridge_information/repository/api_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import '../models/bridge.dart';
import '../repository/db_helper.dart';

//
/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：調度服務
class BridgeService {
  static final BridgeService _instance = BridgeService._internal();

  factory BridgeService() {
    return _instance;
  }

  BridgeService._internal();

  // 數據庫幫助類
  final DatabaseHelper _dbHelper = DatabaseHelper();

  //请求橋樑｜人行橋 数据并缓存到数据库
  Future<Map<String, dynamic>> fetchBridges() async {
    // 从数据库获取橋樑和人行天橋列表
    Tuple2<List<Bridge>?, Database>? bridgesTuple;
    Tuple2<List<PedestrianBridge>?, Database>? pedestrianBridges;
    await Future.wait(
            [_dbHelper.getAllBridges(), _dbHelper.getAllPedestrianBridges()],
            eagerError: true)
        .then((value) async {
      if (value[0] is Tuple2<List<Bridge>?, Database> &&
          value[1] is Tuple2<List<PedestrianBridge>?, Database>?) {
        bridgesTuple = value[0] as Tuple2<List<Bridge>?, Database>?;
        pedestrianBridges =
            value[1] as Tuple2<List<PedestrianBridge>?, Database>?;
        // 關閉資料庫
        if (pedestrianBridges?.item2 != null &&
            pedestrianBridges!.item2.isOpen) {
          await pedestrianBridges!.item2.close();
        }
      }
    });

    // 如果橋樑和人行天橋列表为空，请求api数据
    if ([bridgesTuple?.item1, pedestrianBridges?.item1]
        .any((list) => list == null || list.isEmpty)) {
      //橋樑api
      final bridgesResponse =
          await http.get(Uri.parse(ApiConfig.bridgesUrl('Bridges.json')));
      //人行橋api
      final pedestrianBridgesResponse =
          await http.get(Uri.parse(ApiConfig.bridgesUrl('Footbridges.json')));

      if (bridgesResponse.statusCode == 200 &&
          pedestrianBridgesResponse.statusCode == 200) {
        var bridgeResponse = bridgesResponse.body;
        var pedestrianResponse = pedestrianBridgesResponse.body;

        // 計算數據緩存下載進度 總數和已處理的條目數
        int totalCount = bridgeResponse.length + pedestrianResponse.length;
        int processedCount = 0;

        final bridges =
            parseAndDecodeJson<Bridge>(bridgeResponse, downloadProgress: () {
          processedCount++;
          downloadProgress.value = processedCount / totalCount;
        });
        var pedestrianBridges = parseAndDecodeJson<PedestrianBridge>(
            pedestrianResponse, downloadProgress: () {
          processedCount++;
          downloadProgress.value = processedCount / totalCount;
        });

        pedestrianBridges = pedestrianBridges.map((json) {
              List<BridgesPede> bridges = json.bridges.map((e) {
                    var bridgeJson = e.toJson();
                    bridgeJson['StructureType'] =
                        decodeString(bridgeJson['StructureType']);
                    return BridgesPede.fromJson(bridgeJson);
                  }).toList() ??
                  [];
              return json.copyWith(bridges: bridges);
            }).toList() ??
            [];

        // 保存資料到資料庫
        _dbHelper.insertOrUpdateBridges(bridges);
        _dbHelper.insertOrUpdatePedestrianBridges(pedestrianBridges);

        return {
          'RoadBridges': bridges,
          'FootBridges': pedestrianBridges,
        };
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      //非首次下載打開啟動頁獲取緩存數據庫數據，實時進度已裝載完成
      downloadProgress.value = 1.0;

      // 返回數據庫數據
      return {
        'RoadBridges': bridgesTuple?.item1,
        'FootBridges': pedestrianBridges?.item1,
      };
    }
  }

  // 解析和解碼 JSON 數據
  List<T> parseAndDecodeJson<T>(String responseBody, {downloadProgress}) {
    final List<dynamic> jsonData = json.decode(responseBody);
    return jsonData.map<T>((data) {
      final decodedData = Map<String, dynamic>.from(data);
      decodedData.updateAll((key, value) {
        if (value is String) {
          return decodeString(value);
        }
        return value;
      });

      // 更新下載進度 到 UI組件
      downloadProgress();

      if (T == Bridge) {
        return Bridge.fromJson(decodedData) as T;
      } else if (T == PedestrianBridge) {
        return PedestrianBridge.fromJson(decodedData) as T;
      } else {
        throw Exception('Unknown class');
      }
    }).toList();
  }

  // 解碼字串
  String decodeString(String s) {
    return utf8.decode(s.runes.toList());
  }

  // 首次下載並安裝打開啟動頁獲取api數據，實時進度展示
  final ValueNotifier<double> downloadProgress = ValueNotifier(0.0);
}
