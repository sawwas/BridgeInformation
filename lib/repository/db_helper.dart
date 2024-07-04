import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

import '../models/bridge.dart';
import '../models/pedestrian_bridge.dart';
import 'package:synchronized/synchronized.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/03
/// 描述：數據庫幫助類
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static final BRIDGE_TAG = 'bridges'; //橋樑
  static final PEDESTRIAN_BRIDGE_TAG = 'pedestrian_bridges'; //行人穿越橋
  static final FOOT_BRIDGES_TAG = 'footbridges'; //人行橋 - bridges 對象
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'bridge_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // 橋樑表單
    await db.execute('''
      CREATE TABLE $BRIDGE_TAG (
      ID INTEGER PRIMARY KEY,
      non_bridge TEXT,
      bridge_id TEXT,
      bridge_name TEXT,
      bridge_name_eng TEXT,
      adm TEXT,
      section TEXT,
      CountyCode INTEGER,
      AreaCode INTEGER,
      route TEXT,
      river_cross TEXT,
      double_bridge TEXT,
      designer TEXT,
      engineer TEXT,
      builder TEXT,
      inspect_rate INTEGER,
      locational TEXT,
      structure TEXT,
      total_length REAL,
      area REAL,
      spans REAL,
      width_max REAL,
      width_min REAL,
      driveways INTEGER,
      Longitude_start REAL,
      Latitude_start REAL,
      Longitude_end REAL,
      Latitude_end REAL,
      Obj_Longitude REAL,
      Obj_Latitude REAL
    )
    ''');
    // 行人穿越橋表單
    await db.execute('''
      CREATE TABLE $PEDESTRIAN_BRIDGE_TAG (
        ID INTEGER PRIMARY KEY,
        Footbridge_name TEXT,
        Footbridge_id TEXT,
        adopt_status TEXT,
        AdminUnit TEXT,
        CountyCode INTEGER,
        AreaCode INTEGER,
        Route TEXT,
        CrossoverObject TEXT,
        DesignEngineers TEXT,
        SuperviseEngineers TEXT,
        BuildEngineers TEXT,
        Obj_Longitude REAL,
        Obj_Latitude REAL
      )
    ''');

    // 人行橋 - bridges 對象表單
    await db.execute('''
      CREATE TABLE $FOOT_BRIDGES_TAG (
        BridgeNo TEXT,
        Length REAL,
        Area REAL,
        MaxWidth REAL,
        MinWidth REAL,
        Height REAL,
        DnHeight REAL,
        Longitude_start REAL,
        Latitude_start REAL,
        Longitude_end REAL,
        Latitude_end REAL,
        StructureType TEXT,
        pedestrian_bridge_id INTEGER,
        FOREIGN KEY(pedestrian_bridge_id) REFERENCES $PEDESTRIAN_BRIDGE_TAG(ID)
      )
    ''');
  }

  final rootIsolateToken = ServicesBinding.rootIsolateToken;

  //isolated 處理數據
  Future<T>? isolated<T>(Map<String, dynamic>? data,
      Future<T>? Function(Map<String, dynamic>) callback) async {
    var calculator;
    try {
      calculator = await compute((Map<String, dynamic> maps) async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(
          maps['rootIsolateToken'],
        );
        return maps['callback'](maps);
      }, {
        'callback': callback,
        'rootIsolateToken': rootIsolateToken,
        ...?data
      });
    } catch (e) {}
    return calculator;
  }

  // 批量插入或更新橋樑數據
  Future<bool?>? insertOrUpdateBridges(List<Bridge> bridges) async {
    return await isolated<bool?>({
      'bridges': bridges,
    }, (maps) async {
      Database db = await database;
      await db.transaction((txn) async {
        Batch batch = txn.batch();
        for (var bridge in maps['bridges']) {
          await txn.insert(BRIDGE_TAG, bridge.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
      if (db != null && db.isOpen) {
        await db.close();
      }
      return true;
    });
  }

  // 批量插入或更新人行天橋數據
  Future<bool?>? insertOrUpdatePedestrianBridges(
      List<PedestrianBridge> pedestrianBridges) async {
    return await isolated<bool?>({
      'pedestrianBridges': pedestrianBridges,
    }, (maps) async {
      Database db = await database;
      await db.transaction((txn) async {
        Batch batch = txn.batch();
        for (var bridge in maps['pedestrianBridges']) {
          var mapTemp = bridge.toJson();
          mapTemp.remove('bridges');
          var id = await txn.insert(PEDESTRIAN_BRIDGE_TAG, mapTemp,
              conflictAlgorithm: ConflictAlgorithm.replace);
          await insertOrUpdateFootBridges(bridge.bridges, id, txn);
        }
      });

      if (db != null && db.isOpen) {
        await db.close();
      }
      return true;
    });
  }

  // 批量插入或更新人行天橋數據 for - bridges
  Future<void> insertOrUpdateFootBridges(List<BridgesPede> bridges,
      int pedestrianBridgeId, Transaction txn) async {
    Batch batch = txn.batch();
    for (var bridge in bridges) {
      var bridgeJson = bridge.toJson();
      bridgeJson['pedestrian_bridge_id'] = pedestrianBridgeId;
      await txn.insert(FOOT_BRIDGES_TAG, bridgeJson,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // 取得所有橋樑數據
  Future<Tuple2<List<Bridge>?, Database>?> getAllBridges() async {
    return await isolated<Tuple2<List<Bridge>?, Database>?>(null, (maps) async {
      try {
        Database db = await database;
        final List<Map<String, dynamic>> mapList = await db.query(BRIDGE_TAG);
        var list = List.generate(mapList.length, (i) {
          return Bridge.fromJson(mapList[i]);
        });
        return Tuple2(list, db);
      } catch (e) {
        print(e);
      }
    });
  }

  // 取得所有人行天橋數據並附加 bridges 數據
  Future<Tuple2<List<PedestrianBridge>?, Database>?>
      getAllPedestrianBridges() async {
    return await isolated<Tuple2<List<PedestrianBridge>?, Database>?>(null,
        (maps) async {
      try {
        Database db = await database;
        final List<Map<String, dynamic>> maps =
            await db.query(PEDESTRIAN_BRIDGE_TAG);

        List<PedestrianBridge>? pedestrianBridges = [];
        for (var map in maps) {
          final List<Map<String, dynamic>> bridgeMaps = await db.query(
            FOOT_BRIDGES_TAG,
            where: 'pedestrian_bridge_id = ?',
            whereArgs: [map['ID']],
          );

          List<BridgesPede> bridges = bridgeMaps
              .map((bridgeMap) => BridgesPede.fromJson(bridgeMap))
              .toList();

          PedestrianBridge pedestrianBridge = PedestrianBridge.fromJson(map);
          pedestrianBridge = pedestrianBridge.copyWith(bridges: bridges);

          pedestrianBridges.add(pedestrianBridge);
        }
        return Tuple2(pedestrianBridges, db);
      } catch (e) {
        print(e);
      }
    });
  }
}
