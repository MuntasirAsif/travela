import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../data/model/search_item.dart';

class BadgeRow extends StatelessWidget {
  const BadgeRow({super.key, required this.item});

  final SearchItem item;

  @override
  Widget build(BuildContext context) {
    final badge = item.featuredBadge;
    return Row(
      children: [
        if (badge != null)
          _SmallChip(
            label: badge.name,
            background: context.color.primary,
            foreground: context.color.onPrimary,
          ),
        if (item.isHotel) ...[
          SizedBox(width: context.spacing.s6),
          _SmallChip(
            label: 'Hotel',
            background: context.color.warning.withValues(alpha: 0.15),
            foreground: context.color.warning,
          ),
        ],
      ],
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({super.key, required this.item});

  final SearchItem item;

  @override
  Widget build(BuildContext context) {
    final offer = item.offerPrice;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formatPrice(item.offerPrice ?? item.price),
          style: context.textStyle.titleMedium.copyWith(
            color: context.color.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (offer != null) ...[
          SizedBox(width: context.spacing.s8),
          Text(
            formatPrice(item.price),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
        const Spacer(),
        if (item.maxGuest > 0)
          Text(
            '${item.maxGuest} guests',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
      ],
    );
  }
}

class ReviewsRow extends StatelessWidget {
  const ReviewsRow({super.key, required this.rating, this.count});

  final double rating;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, size: 14.sp, color: Colors.amber.shade600),
        SizedBox(width: context.spacing.s4),
        Text(rating.toStringAsFixed(1), style: context.textStyle.labelMedium),
        if (count != null) ...[
          SizedBox(width: context.spacing.s6),
          Text(
            '($count)',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ],
    );
  }
}

String formatPrice(int value) {
  final digits = value.toString();
  final buffer = StringBuffer('৳');
  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) buffer.write(',');
  }
  return buffer.toString();
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.s8,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.radius.r20),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmall.copyWith(color: foreground),
      ),
    );
  }
}
