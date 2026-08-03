import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../view_model/property_search_provider.dart';
import '../../view_model/property_search_state.dart';

class SearchHeader extends ConsumerWidget {
  const SearchHeader({super.key, required this.collapse});

  final Animation<double> collapse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertySearchViewModelProvider);
    final status = state.status;

    final String subtitle;
    switch (status) {
      case PropertySearchStatus.idle:
        subtitle = 'Pick a location, set filters, and hit Search.';
      case PropertySearchStatus.loading:
        subtitle = 'Opening results…';
      case PropertySearchStatus.streaming:
        subtitle = state.totalCount > 0
            ? '${state.items.length} of ${state.totalCount} stays'
            : '${state.items.length} stays so far';
      case PropertySearchStatus.done:
        subtitle = '${state.totalCount} stays';
      case PropertySearchStatus.error:
        subtitle = 'Search failed';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where to next?',
          style: context.textStyle.headlineMedium.copyWith(
            color: context.color.headerText,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizeTransition(
          sizeFactor: ReverseAnimation(collapse),
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: ReverseAnimation(collapse),
            child: Text(
              subtitle,
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.headerText.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
