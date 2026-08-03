import 'package:json_annotation/json_annotation.dart';

part 'meta_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MetaEvent {
  final int totalCount;
  final MetaPagination? pagination;

  const MetaEvent({this.totalCount = 0, this.pagination});

  factory MetaEvent.fromJson(Map<String, dynamic> json) =>
      _$MetaEventFromJson(json);

  Map<String, dynamic> toJson() => _$MetaEventToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MetaPagination {
  final int page;
  final int limit;
  final int totalCount;
  final int? next;
  final int totalPage;

  const MetaPagination({
    this.page = 1,
    this.limit = 20,
    this.totalCount = 0,
    this.next,
    this.totalPage = 1,
  });

  factory MetaPagination.fromJson(Map<String, dynamic> json) =>
      _$MetaPaginationFromJson(json);

  Map<String, dynamic> toJson() => _$MetaPaginationToJson(this);
}
