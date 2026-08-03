import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../../../widgets/custom_network_image.dart';
import '../../../data/model/search_item.dart';
import 'search_result_card_parts.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.item});

  final SearchItem item;

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
          CustomNetworkImage(
            imageUrl: item.primaryImage?.url ?? '',
            height: 104.h,
            width: 104.w,
            radius: context.radius.r12,
          ),
          SizedBox(width: context.spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadgeRow(item: item),
                SizedBox(height: context.spacing.s4),
                Text(
                  item.title,
                  style: context.textStyle.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.spacing.s4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 14.sp,
                      color: context.color.text.secondary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        item.address,
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spacing.s8),
                PriceRow(item: item),
                if (item.reviewsAvg != null) ...[
                  SizedBox(height: context.spacing.s4),
                  ReviewsRow(
                    rating: item.reviewsAvg!,
                    count: item.reviewsCount,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
