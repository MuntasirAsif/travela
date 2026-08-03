// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaEvent _$MetaEventFromJson(Map<String, dynamic> json) => MetaEvent(
  totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
  pagination: json['pagination'] == null
      ? null
      : MetaPagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MetaEventToJson(MetaEvent instance) => <String, dynamic>{
  'total_count': instance.totalCount,
  'pagination': instance.pagination,
};

MetaPagination _$MetaPaginationFromJson(Map<String, dynamic> json) =>
    MetaPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      next: (json['next'] as num?)?.toInt(),
      totalPage: (json['total_page'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MetaPaginationToJson(MetaPagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total_count': instance.totalCount,
      'next': instance.next,
      'total_page': instance.totalPage,
    };
