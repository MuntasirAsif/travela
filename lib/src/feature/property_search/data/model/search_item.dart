import 'package:json_annotation/json_annotation.dart';

import 'featured_badge.dart';
import 'search_item_image.dart';

part 'search_item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchItem {
  final int id;
  final String title;
  final String address;
  final int price;
  final int? offerPrice;
  final double? reviewsAvg;
  final int? reviewsCount;
  final List<SearchItemImage> images;
  final bool isHotel;
  final FeaturedBadge? featuredBadge;
  final int bedroom;
  final int beds;
  final int bathroom;
  final int maxGuest;

  const SearchItem({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    this.offerPrice,
    this.reviewsAvg,
    this.reviewsCount,
    this.images = const [],
    this.isHotel = false,
    this.featuredBadge,
    this.bedroom = 0,
    this.beds = 0,
    this.bathroom = 0,
    this.maxGuest = 0,
  });

  SearchItemImage? get primaryImage => images.isEmpty ? null : images.first;

  factory SearchItem.fromJson(Map<String, dynamic> json) =>
      _$SearchItemFromJson(json);

  Map<String, dynamic> toJson() => _$SearchItemToJson(this);
}
