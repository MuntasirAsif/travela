import 'dart:ui' show lerpDouble;

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

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSearch());
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    final pixels = notification.metrics.pixels;
    if (pixels > 120) {
      if (!_headerController.isCompleted) _headerController.forward();
    } else if (pixels < 48 && _headerController.value > 0) {
      _headerController.reverse();
    }
    return false;
  }

  void _startSearch() {
    final location = ref.read(locationSearchViewModelProvider).selected;
    final filters = ref.read(searchFiltersProvider);
    ref
        .read(propertySearchViewModelProvider.notifier)
        .startSearch(filters.copyWith(location: location ?? filters.location));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertySearchViewModelProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedBuilder(
            animation: _headerController,
            builder: (context, child) {
              final t = _headerController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.color.headerGradientStart,
                      context.color.headerGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(context.radius.r32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.color.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.padding.p20,
                      context.spacing.s16,
                      context.padding.p20,
                      lerpDouble(context.spacing.s24, context.spacing.s12, t)!,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchHeader(collapse: _headerController),
                        SizeTransition(
                          sizeFactor: ReverseAnimation(_headerController),
                          alignment: Alignment.topLeft,
                          child: FadeTransition(
                            opacity: ReverseAnimation(_headerController),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: context.spacing.s16),
                                const LocationSearchField(),
                                SizedBox(height: context.spacing.s16),
                                FilterRow(),
                                SizedBox(height: context.spacing.s24),
                                FilledButton(
                                  onPressed: _startSearch,
                                  style: FilledButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      56,
                                    ),
                                    backgroundColor: context.color.headerText,
                                    foregroundColor:
                                        context.color.headerGradientStart,
                                    elevation: 4,
                                    shadowColor: context.color.headerText
                                        .withValues(alpha: 0.25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.radius.r16,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Search stays',
                                    style: context.textStyle.titleMedium
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScroll,
              child: _buildBody(state),
            ),
          ),
        ],
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
        return ResultsPane(
          state: state,
          onLoadMore: () =>
              ref.read(propertySearchViewModelProvider.notifier).loadMore(),
        );
    }
  }
}
