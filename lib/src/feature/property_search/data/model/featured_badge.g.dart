// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedBadge _$FeaturedBadgeFromJson(Map<String, dynamic> json) =>
    FeaturedBadge(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$FeaturedBadgeToJson(FeaturedBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'icon': instance.icon,
    };
