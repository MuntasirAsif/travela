import 'package:flutter_riverpod/legacy.dart';

import 'property_search_state.dart';
import 'property_search_view_model.dart';

final propertySearchViewModelProvider =
    StateNotifierProvider.autoDispose<
      PropertySearchViewModel,
      PropertySearchState
    >((ref) => PropertySearchViewModel());
