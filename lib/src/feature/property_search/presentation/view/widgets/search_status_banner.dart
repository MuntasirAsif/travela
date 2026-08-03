import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../view_model/property_search_state.dart';

class SearchStatusBanner extends StatelessWidget {
  const SearchStatusBanner({
    super.key,
    required this.status,
    required this.totalCount,
  });

  final PropertySearchStatus status;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    if (status == PropertySearchStatus.streaming) {
      return _Banner(
        color: context.color.primary.withValues(alpha: 0.06),
        child: Row(
          children: [
            SizedBox(
              width: 14.r,
              height: 14.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.color.primary,
              ),
            ),
            SizedBox(width: context.spacing.s8),
            Text(
              'Receiving results…',
              style: context.textStyle.labelMedium.copyWith(
                color: context.color.primary,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.padding.p16,
        vertical: context.spacing.s8,
      ),
      color: color,
      child: child,
    );
  }
}
