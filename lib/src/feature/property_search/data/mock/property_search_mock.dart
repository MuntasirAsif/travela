import '../model/location.dart';
import '../model/search_item.dart';
import 'mock_items.dart';
import 'mock_locations.dart';

class PropertySearchMock {
  static const Location primaryLocation = MockLocations.coxsBazar;

  static List<SearchItem> get items => MockItems.all;

  static Future<List<Location>> searchLocations(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final trimmed = query.trim();
    if (trimmed.isEmpty) return MockLocations.all;
    final q = trimmed.toLowerCase();
    return MockLocations.all
        .where(
          (l) => l.name.toLowerCase().contains(q) || l.nameBn.contains(trimmed),
        )
        .toList();
  }
}
