import '../../data/model/location.dart';

class SearchFilters {
  final Location? location;
  final DateTime? from;
  final DateTime? to;
  final int guest;
  final int rooms;
  final double minPrice;
  final double maxPrice;

  const SearchFilters({
    this.location,
    this.from,
    this.to,
    this.guest = 2,
    this.rooms = 1,
    this.minPrice = 0,
    this.maxPrice = 5000,
  });

  String? get fromLabel => formatDate(from);
  String? get toLabel => formatDate(to);
  String get priceLabel => '${minPrice.round()}-${maxPrice.round()}';

  static String? formatDate(DateTime? date) {
    if (date == null) return null;
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  SearchFilters copyWith({
    Location? location,
    DateTime? from,
    DateTime? to,
    int? guest,
    int? rooms,
    double? minPrice,
    double? maxPrice,
  }) {
    return SearchFilters(
      location: location ?? this.location,
      from: from ?? this.from,
      to: to ?? this.to,
      guest: guest ?? this.guest,
      rooms: rooms ?? this.rooms,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
