import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/static/theme/theme.dart';
import '../view_model/location_search_provider.dart';
import '../view_model/property_search_provider.dart';
import '../view_model/property_search_state.dart';
import '../view_model/search_filters_provider.dart';
import 'widgets/filter_row.dart';
import 'widgets/location_search_field.dart';
import 'widgets/results_pane.dart';
import 'widgets/search_header.dart';
import 'widgets/search_placeholders.dart';

class PropertySearchScreen extends ConsumerStatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  ConsumerState<PropertySearchScreen> createState() =>
      _PropertySearchScreenState();
}

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSearch());
  }

  void _startSearch() {
    final location = ref.read(locationSearchViewModelProvider).selected;
    final filters = ref.read(searchFiltersProvider);
    ref
        .read(propertySearchViewModelProvider.notifier)
        .startMockSearch(
          filters.copyWith(location: location ?? filters.location),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertySearchViewModelProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.padding.p16,
                context.spacing.s16,
                context.padding.p16,
                context.spacing.s12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchHeader(),
                  SizedBox(height: context.spacing.s16),
                  const LocationSearchField(),
                  SizedBox(height: context.spacing.s12),
                  FilterRow(onSearch: _startSearch),
                ],
              ),
            ),
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PropertySearchState state) {
    switch (state.status) {
      case PropertySearchStatus.idle:
        return const IdlePlaceholder();
      case PropertySearchStatus.loading:
        return const LoadingPlaceholder();
      case PropertySearchStatus.error:
        return ErrorPlaceholder(
          message: state.errorMessage,
          onRetry: _startSearch,
        );
      case PropertySearchStatus.streaming:
      case PropertySearchStatus.done:
        if (state.items.isEmpty) return const EmptyPlaceholder();
        return ResultsPane(state: state);
    }
  }
}
