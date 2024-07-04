import 'package:json_annotation/json_annotation.dart';

part 'pedestrian_bridge.g.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：人行天橋
@JsonSerializable(explicitToJson: true)
class PedestrianBridge {
  @JsonKey(defaultValue: 0)
  final int ID;
  @JsonKey(name: 'Footbridge_name', defaultValue: '')
  final String footbridgeName;
  @JsonKey(name: 'Footbridge_id', defaultValue: '')
  final String footbridgeId;
  @JsonKey(name: 'adopt_status', defaultValue: '')
  final String adoptStatus;
  @JsonKey(defaultValue: '')
  final String AdminUnit;
  @JsonKey(defaultValue: 0)
  final int CountyCode;
  @JsonKey(defaultValue: 0)
  final int AreaCode;
  @JsonKey(defaultValue: '')
  final String Route;
  @JsonKey(defaultValue: '')
  final String CrossoverObject;
  @JsonKey(defaultValue: '')
  final String DesignEngineers;
  @JsonKey(defaultValue: '')
  final String SuperviseEngineers;
  @JsonKey(defaultValue: '')
  final String BuildEngineers;
  @JsonKey(name: 'Obj_Longitude', defaultValue: 0)
  final double objLongitude;
  @JsonKey(name: 'Obj_Latitude', defaultValue: 0)
  final double objLatitude;
  @JsonKey(name: 'Bridges', defaultValue: [])
  final List<BridgesPede> bridges;

  const PedestrianBridge({
    required this.ID,
    required this.footbridgeName,
    required this.footbridgeId,
    required this.adoptStatus,
    required this.AdminUnit,
    required this.CountyCode,
    required this.AreaCode,
    required this.Route,
    required this.CrossoverObject,
    required this.DesignEngineers,
    required this.SuperviseEngineers,
    required this.BuildEngineers,
    required this.objLongitude,
    required this.objLatitude,
    required this.bridges,
  });

  factory PedestrianBridge.fromJson(Map<String, dynamic> json) =>
      _$PedestrianBridgeFromJson(json);

  Map<String, Object?> toJson() => _$PedestrianBridgeToJson(this);

  PedestrianBridge copyWith({
    int? ID,
    String? footbridgeName,
    String? footbridgeId,
    String? adoptStatus,
    String? AdminUnit,
    int? CountyCode,
    int? AreaCode,
    String? Route,
    String? CrossoverObject,
    String? DesignEngineers,
    String? SuperviseEngineers,
    String? BuildEngineers,
    double? objLongitude,
    double? objLatitude,
    List<BridgesPede>? bridges,
  }) {
    return PedestrianBridge(
      ID: ID ?? this.ID,
      footbridgeName: footbridgeName ?? this.footbridgeName,
      footbridgeId: footbridgeId ?? this.footbridgeId,
      adoptStatus: adoptStatus ?? this.adoptStatus,
      AdminUnit: AdminUnit ?? this.AdminUnit,
      CountyCode: CountyCode ?? this.CountyCode,
      AreaCode: AreaCode ?? this.AreaCode,
      Route: Route ?? this.Route,
      CrossoverObject: CrossoverObject ?? this.CrossoverObject,
      DesignEngineers: DesignEngineers ?? this.DesignEngineers,
      SuperviseEngineers: SuperviseEngineers ?? this.SuperviseEngineers,
      BuildEngineers: BuildEngineers ?? this.BuildEngineers,
      objLongitude: objLongitude ?? this.objLongitude,
      objLatitude: objLatitude ?? this.objLatitude,
      bridges: bridges ?? this.bridges,
    );
  }
}

@JsonSerializable()
class BridgesPede {
  @JsonKey(defaultValue: '')
  final String BridgeNo;
  @JsonKey(defaultValue: 0)
  final double Length;
  @JsonKey(defaultValue: 0)
  final int Area;
  @JsonKey(defaultValue: 0)
  final int MaxWidth;
  @JsonKey(defaultValue: 0)
  final double MinWidth;
  @JsonKey(defaultValue: 0)
  final double Height;
  @JsonKey(defaultValue: 0)
  final double DnHeight;
  @JsonKey(name: 'Longitude_start', defaultValue: 0)
  final double longitudeStart;
  @JsonKey(name: 'Latitude_start', defaultValue: 0)
  final double latitudeStart;
  @JsonKey(name: 'Longitude_end', defaultValue: 0)
  final double longitudeEnd;
  @JsonKey(name: 'Latitude_end', defaultValue: 0)
  final double latitudeEnd;
  @JsonKey(defaultValue: '')
  final String StructureType;

  const BridgesPede({
    required this.BridgeNo,
    required this.Length,
    required this.Area,
    required this.MaxWidth,
    required this.MinWidth,
    required this.Height,
    required this.DnHeight,
    required this.longitudeStart,
    required this.latitudeStart,
    required this.longitudeEnd,
    required this.latitudeEnd,
    required this.StructureType,
  });

  factory BridgesPede.fromJson(Map<String, dynamic> json) =>
      _$BridgesFromJson(json);

  Map<String, dynamic> toJson() => _$BridgesToJson(this);
}
