import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../view_model/property_search_provider.dart';
import '../../view_model/property_search_state.dart';

class SearchHeader extends ConsumerWidget {
  const SearchHeader({super.key, required this.collapse, this.onExpand});

  final Animation<double> collapse;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertySearchViewModelProvider);
    final status = state.status;

    final String subtitle;
    final String compact;
    final String? compactHint;
    switch (status) {
      case PropertySearchStatus.idle:
        subtitle = 'Pick a location, set filters, and hit Search.';
        compact = 'Ready to search';
        compactHint = null;
      case PropertySearchStatus.loading:
        subtitle = 'Opening results…';
        compact = 'Loading results…';
        compactHint = null;
      case PropertySearchStatus.streaming:
        subtitle = state.totalCount > 0
            ? '${state.items.length} of ${state.totalCount} stays'
            : '${state.items.length} stays so far';
        if (state.totalCount > 0) {
          compact = 'showing ${state.items.length} out of ${state.totalCount}';
          compactHint = 'scroll down to load more';
        } else {
          compact = '${state.items.length} loaded';
          compactHint = null;
        }
      case PropertySearchStatus.done:
        subtitle = '${state.totalCount} stays';
        if (state.totalCount > 0) {
          compact = 'showing ${state.items.length} out of ${state.totalCount}';
          compactHint = state.hasMore ? 'scroll down to load more' : null;
        } else {
          compact = 'No results';
          compactHint = null;
        }
      case PropertySearchStatus.error:
        subtitle = 'Search failed';
        compact = 'Search failed';
        compactHint = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizeTransition(
          sizeFactor: collapse,
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: collapse,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Where to next?',
                        style: context.textStyle.titleMedium.copyWith(
                          color: context.color.headerText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onExpand,
                      tooltip: 'Show search options',
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        Icons.expand_more,
                        color: context.color.headerText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spacing.s4),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.padding.p12,
                    vertical: context.spacing.s6,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.headerText.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.radius.r10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Icon(
                        Icons.king_bed_outlined,
                        size: 14.r,
                        color: context.color.headerText.withValues(alpha: 0.8),
                      ),
                      SizedBox(width: context.spacing.s6),
                      Flexible(
                        child: Text(
                          compact,
                          style: context.textStyle.bodySmall.copyWith(
                            color: context.color.headerText.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (compactHint != null) ...[
                        SizedBox(width: context.spacing.s8),
                        Flexible(
                          child: Text(
                            compactHint,
                            style: context.textStyle.bodySmall.copyWith(
                              color: context.color.headerText,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: ReverseAnimation(collapse),
          alignment: Alignment.topLeft,
          child: FadeTransition(
            opacity: ReverseAnimation(collapse),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where to next?',
                  style: context.textStyle.headlineMedium.copyWith(
                    color: context.color.headerText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: context.spacing.s4),
                Text(
                  subtitle,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.headerText.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
