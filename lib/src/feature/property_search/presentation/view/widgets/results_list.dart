import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../data/model/search_item.dart';
import 'search_result_card.dart';

class SearchResultsList extends StatefulWidget {
  const SearchResultsList({
    super.key,
    required this.items,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  final List<SearchItem> items;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (widget.hasMore &&
        !widget.isLoadingMore &&
        position.pixels >= position.maxScrollExtent - 200) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length + (widget.isLoadingMore ? 1 : 0);
    return ListView.separated(
      controller: _controller,
      padding: EdgeInsets.fromLTRB(
        context.padding.p16,
        context.spacing.s4,
        context.padding.p16,
        context.spacing.s16,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: context.spacing.s12),
      itemBuilder: (context, index) {
        if (index >= widget.items.length) return const _LoadingMoreRow();
        return _StreamInItem(
          child: SearchResultCard(item: widget.items[index]),
        );
      },
    );
  }
}

class _LoadingMoreRow extends StatelessWidget {
  const _LoadingMoreRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.s12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16.r,
            height: 16.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.color.primary,
            ),
          ),
          SizedBox(width: context.spacing.s8),
          Text(
            'Loading more…',
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
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
