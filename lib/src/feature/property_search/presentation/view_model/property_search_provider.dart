import 'package:flutter_riverpod/legacy.dart';

import '../../domain/provider/property_search_repository_provider.dart';
import 'property_search_state.dart';
import 'property_search_view_model.dart';

final propertySearchViewModelProvider =
    StateNotifierProvider.autoDispose<
      PropertySearchViewModel,
      PropertySearchState
    >(
      (ref) =>
          PropertySearchViewModel(ref.watch(propertySearchRepositoryProvider)),
    );
