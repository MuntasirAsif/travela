// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchItem _$SearchItemFromJson(Map<String, dynamic> json) => SearchItem(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  address: json['address'] as String,
  price: (json['price'] as num).toInt(),
  offerPrice: (json['offer_price'] as num?)?.toInt(),
  reviewsAvg: (json['reviews_avg'] as num?)?.toDouble(),
  reviewsCount: (json['reviews_count'] as num?)?.toInt(),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => SearchItemImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isHotel: json['is_hotel'] as bool? ?? false,
  featuredBadge: json['featured_badge'] == null
      ? null
      : FeaturedBadge.fromJson(json['featured_badge'] as Map<String, dynamic>),
  bedroom: (json['bedroom'] as num?)?.toInt() ?? 0,
  beds: (json['beds'] as num?)?.toInt() ?? 0,
  bathroom: (json['bathroom'] as num?)?.toInt() ?? 0,
  maxGuest: (json['max_guest'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SearchItemToJson(SearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'price': instance.price,
      'offer_price': instance.offerPrice,
      'reviews_avg': instance.reviewsAvg,
      'reviews_count': instance.reviewsCount,
      'images': instance.images,
      'is_hotel': instance.isHotel,
      'featured_badge': instance.featuredBadge,
      'bedroom': instance.bedroom,
      'beds': instance.beds,
      'bathroom': instance.bathroom,
      'max_guest': instance.maxGuest,
    };
