import 'package:flutter/material.dart';

import '../../view_model/property_search_state.dart';
import 'results_list.dart';
import 'search_status_banner.dart';

class ResultsPane extends StatelessWidget {
  const ResultsPane({super.key, required this.state});

  final PropertySearchState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SearchResultsList(items: state.items)),
        SearchStatusBanner(status: state.status, totalCount: state.totalCount),
      ],
    );
  }
}
