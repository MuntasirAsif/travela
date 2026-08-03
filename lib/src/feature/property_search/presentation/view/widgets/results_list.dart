import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../data/model/search_item.dart';
import 'search_result_card.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.items});

  final List<SearchItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        context.padding.p16,
        context.spacing.s4,
        context.padding.p16,
        context.spacing.s16,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: context.spacing.s12),
      itemBuilder: (context, index) =>
          _StreamInItem(child: SearchResultCard(item: items[index])),
    );
  }
}

class _StreamInItem extends StatelessWidget {
  const _StreamInItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12.h * (1 - value)),
          child: child,
        ),
      ),
    );
  }
}
