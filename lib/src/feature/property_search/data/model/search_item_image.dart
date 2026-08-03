import 'package:json_annotation/json_annotation.dart';

part 'search_item_image.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchItemImage {
  final int? id;
  final String url;

  const SearchItemImage({this.id, required this.url});

  factory SearchItemImage.fromJson(Map<String, dynamic> json) =>
      _$SearchItemImageFromJson(json);

  Map<String, dynamic> toJson() => _$SearchItemImageToJson(this);
}
