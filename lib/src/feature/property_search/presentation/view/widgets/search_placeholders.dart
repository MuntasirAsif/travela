import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../../../widgets/empty_state_widget.dart';

class IdlePlaceholder extends StatelessWidget {
  const IdlePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.search_rounded,
      title: 'Search for stays',
      subtitle: 'Pick a location, set your filters, and hit Search.',
      showButton: false,
    );
  }
}

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          context.padding.p16,
          context.spacing.s4,
          context.padding.p16,
          context.spacing.s16,
        ),
        itemCount: 6,
        separatorBuilder: (_, _) => SizedBox(height: context.spacing.s12),
        itemBuilder: (context, index) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.padding.p12),
      decoration: BoxDecoration(
        color: context.color.textFieldFillColor,
        borderRadius: BorderRadius.circular(context.radius.r16),
        border: Border.all(color: context.color.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 104.h,
            width: 104.w,
            decoration: BoxDecoration(
              color: context.color.text.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(context.radius.r12),
            ),
          ),
          SizedBox(width: context.spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _chip(context, 48.w),
                    SizedBox(width: context.spacing.s8),
                    _chip(context, 64.w),
                  ],
                ),
                SizedBox(height: context.spacing.s8),
                Text(
                  'Title placeholder',
                  style: context.textStyle.titleSmall,
                  maxLines: 1,
                ),
                SizedBox(height: context.spacing.s8),
                Text(
                  'Address placeholder',
                  style: context.textStyle.bodySmall,
                  maxLines: 1,
                ),
                SizedBox(height: context.spacing.s12),
                Text(
                  'Price placeholder',
                  style: context.textStyle.titleMedium,
                  maxLines: 1,
                ),
                SizedBox(height: context.spacing.s8),
                Text(
                  'Reviews placeholder',
                  style: context.textStyle.bodySmall,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, double width) {
    return Container(
      height: 20.h,
      width: width,
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
}

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.bed_outlined,
      title: 'No stays found',
      subtitle: 'Try adjusting your filters or a different location.',
      showButton: false,
    );
  }
}

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.error_outline_rounded,
      title: 'Search failed',
      subtitle: message ?? 'Something went wrong. Please try again.',
      customButton: FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Try again'),
      ),
    );
  }
}
