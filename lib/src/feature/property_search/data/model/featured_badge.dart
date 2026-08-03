import 'package:json_annotation/json_annotation.dart';

part 'featured_badge.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FeaturedBadge {
  final int? id;
  final String name;
  final String slug;
  final String? icon;

  const FeaturedBadge({
    this.id,
    required this.name,
    required this.slug,
    this.icon,
  });

  factory FeaturedBadge.fromJson(Map<String, dynamic> json) =>
      _$FeaturedBadgeFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedBadgeToJson(this);
}
