// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedestrian_bridge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedestrianBridge _$PedestrianBridgeFromJson(Map<String, dynamic> json) =>
    PedestrianBridge(
      ID: (json['ID'] as num?)?.toInt() ?? 0,
      footbridgeName: json['Footbridge_name'] as String? ?? '',
      footbridgeId: json['Footbridge_id'] as String? ?? '',
      adoptStatus: json['adopt_status'] as String? ?? '',
      AdminUnit: json['AdminUnit'] as String? ?? '',
      CountyCode: (json['CountyCode'] as num?)?.toInt() ?? 0,
      AreaCode: (json['AreaCode'] as num?)?.toInt() ?? 0,
      Route: json['Route'] as String? ?? '',
      CrossoverObject: json['CrossoverObject'] as String? ?? '',
      DesignEngineers: json['DesignEngineers'] as String? ?? '',
      SuperviseEngineers: json['SuperviseEngineers'] as String? ?? '',
      BuildEngineers: json['BuildEngineers'] as String? ?? '',
      objLongitude: (json['Obj_Longitude'] as num?)?.toDouble() ?? 0,
      objLatitude: (json['Obj_Latitude'] as num?)?.toDouble() ?? 0,
      bridges: (json['Bridges'] as List<dynamic>?)
              ?.map((e) => BridgesPede.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, Object?> _$PedestrianBridgeToJson(PedestrianBridge instance) =>
    <String, Object?>{
      'ID': instance.ID,
      'Footbridge_name': instance.footbridgeName,
      'Footbridge_id': instance.footbridgeId,
      'adopt_status': instance.adoptStatus,
      'AdminUnit': instance.AdminUnit,
      'CountyCode': instance.CountyCode,
      'AreaCode': instance.AreaCode,
      'Route': instance.Route,
      'CrossoverObject': instance.CrossoverObject,
      'DesignEngineers': instance.DesignEngineers,
      'SuperviseEngineers': instance.SuperviseEngineers,
      'BuildEngineers': instance.BuildEngineers,
      'Obj_Longitude': instance.objLongitude,
      'Obj_Latitude': instance.objLatitude,
      'bridges': instance.bridges.map((e) => e.toJson()).toList(),
    };

BridgesPede _$BridgesFromJson(Map<String, dynamic> json) => BridgesPede(
      BridgeNo: json['BridgeNo'] as String? ?? '',
      Length: (json['Length'] as num?)?.toDouble() ?? 0,
      Area: (json['Area'] as num?)?.toInt() ?? 0,
      MaxWidth: (json['MaxWidth'] as num?)?.toInt() ?? 0,
      MinWidth: (json['MinWidth'] as num?)?.toDouble() ?? 0,
      Height: (json['Height'] as num?)?.toDouble() ?? 0,
      DnHeight: (json['DnHeight'] as num?)?.toDouble() ?? 0,
      longitudeStart: (json['Longitude_start'] as num?)?.toDouble() ?? 0,
      latitudeStart: (json['Latitude_start'] as num?)?.toDouble() ?? 0,
      longitudeEnd: (json['Longitude_end'] as num?)?.toDouble() ?? 0,
      latitudeEnd: (json['Latitude_end'] as num?)?.toDouble() ?? 0,
      StructureType: json['StructureType'] as String? ?? '',
    );

Map<String, dynamic> _$BridgesToJson(BridgesPede instance) => <String, dynamic>{
      'BridgeNo': instance.BridgeNo,
      'Length': instance.Length,
      'Area': instance.Area,
      'MaxWidth': instance.MaxWidth,
      'MinWidth': instance.MinWidth,
      'Height': instance.Height,
      'DnHeight': instance.DnHeight,
      'Longitude_start': instance.longitudeStart,
      'Latitude_start': instance.latitudeStart,
      'Longitude_end': instance.longitudeEnd,
      'Latitude_end': instance.latitudeEnd,
      'StructureType': instance.StructureType,
    };
