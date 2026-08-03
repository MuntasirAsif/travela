import 'package:flutter/material.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../../../widgets/custom_loading_indicator.dart';
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomLoadingIndicator(),
          SizedBox(height: context.spacing.s16),
          Text(
            'Opening search stream…',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
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
