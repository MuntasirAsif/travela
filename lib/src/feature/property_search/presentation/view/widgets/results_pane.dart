import 'package:flutter/material.dart';

import '../../view_model/property_search_state.dart';
import 'results_list.dart';
import 'search_status_banner.dart';

class ResultsPane extends StatelessWidget {
  const ResultsPane({
    super.key,
    required this.state,
    required this.onLoadMore,
    required this.controller,
  });

  final PropertySearchState state;
  final VoidCallback onLoadMore;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SearchResultsList(
            controller: controller,
            items: state.items,
            hasMore: state.hasMore,
            isLoadingMore: state.isLoadingMore,
            onLoadMore: onLoadMore,
          ),
        ),
        SearchStatusBanner(
          status: state.status,
          totalCount: state.totalCount,
          hasMore: state.hasMore,
        ),
      ],
    );
  }
}
