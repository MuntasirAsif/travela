import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Location {
  final int id;
  final String name;
  final String? nameBn;
  final int order;
  final double lat;
  final double lng;
  final double within;

  @JsonKey(name: 'tier_1')
  final double tier1;

  @JsonKey(name: 'tier_2')
  final double tier2;

  const Location({
    required this.id,
    required this.name,
    this.nameBn,
    required this.order,
    required this.lat,
    required this.lng,
    required this.within,
    required this.tier1,
    required this.tier2,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
