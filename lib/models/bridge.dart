import 'package:json_annotation/json_annotation.dart';

part 'bridge.g.dart';

/// 作者：SanDaoHai
/// 日期：2024/07/02
/// 描述：橋樑
@JsonSerializable()
class Bridge {
  @JsonKey(defaultValue: 0)
  final int ID;
  @JsonKey(name: 'non_bridge', defaultValue: '')
  final String nonBridge;
  @JsonKey(name: 'bridge_id', defaultValue: '')
  final String bridgeId;
  @JsonKey(name: 'bridge_name', defaultValue: '')
  final String bridgeName;
  @JsonKey(name: 'bridge_name_eng', defaultValue: '')
  final String bridgeNameEng;
  @JsonKey(defaultValue: '')
  final String adm;
  @JsonKey(defaultValue: '')
  final String section;
  @JsonKey(defaultValue: 0)
  final int CountyCode;
  @JsonKey(defaultValue: 0)
  final int AreaCode;
  @JsonKey(defaultValue: '')
  final String route;
  @JsonKey(name: 'river_cross', defaultValue: '')
  final String riverCross;
  @JsonKey(name: 'double_bridge', defaultValue: '')
  final String doubleBridge;
  @JsonKey(defaultValue: '')
  final String designer;
  @JsonKey(defaultValue: '')
  final String engineer;
  @JsonKey(defaultValue: '')
  final String builder;
  @JsonKey(name: 'inspect_rate', defaultValue: 0)
  final int inspectRate;
  @JsonKey(defaultValue: '')
  final String locational;
  @JsonKey(defaultValue: '')
  final String structure;
  @JsonKey(name: 'total_length', defaultValue: 0)
  final double totalLength;
  @JsonKey(defaultValue: 0)
  final double area;
  @JsonKey(defaultValue: 0)
  final int spans;
  @JsonKey(name: 'width_max', defaultValue: 0)
  final double widthMax;
  @JsonKey(name: 'width_min', defaultValue: 0)
  final double widthMin;
  @JsonKey(defaultValue: 0)
  final int driveways;
  @JsonKey(name: 'Longitude_start', defaultValue: 0)
  final double longitudeStart;
  @JsonKey(name: 'Latitude_start', defaultValue: 0)
  final double latitudeStart;
  @JsonKey(name: 'Longitude_end', defaultValue: 0)
  final double longitudeEnd;
  @JsonKey(name: 'Latitude_end', defaultValue: 0)
  final double latitudeEnd;
  @JsonKey(name: 'Obj_Longitude', defaultValue: 0)
  final double objLongitude;
  @JsonKey(name: 'Obj_Latitude', defaultValue: 0)
  final double objLatitude;

  const Bridge({
    required this.ID,
    required this.nonBridge,
    required this.bridgeId,
    required this.bridgeName,
    required this.bridgeNameEng,
    required this.adm,
    required this.section,
    required this.CountyCode,
    required this.AreaCode,
    required this.route,
    required this.riverCross,
    required this.doubleBridge,
    required this.designer,
    required this.engineer,
    required this.builder,
    required this.inspectRate,
    required this.locational,
    required this.structure,
    required this.totalLength,
    required this.area,
    required this.spans,
    required this.widthMax,
    required this.widthMin,
    required this.driveways,
    required this.longitudeStart,
    required this.latitudeStart,
    required this.longitudeEnd,
    required this.latitudeEnd,
    required this.objLongitude,
    required this.objLatitude,
  });

  factory Bridge.fromJson(Map<String, dynamic> json) =>
      _$BridgeFromJson(json);

  Map<String, dynamic> toJson() => _$BridgeToJson(this);
}
