import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../view_model/search_filters_provider.dart';

void showGuestPickerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => const _GuestPickerSheet(),
  );
}

void showPriceRangeSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => const _PriceRangeSheet(),
  );
}

class _GuestPickerSheet extends ConsumerWidget {
  const _GuestPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guest = ref.watch(
      searchFiltersProvider.select((state) => state.guest),
    );
    final notifier = ref.read(searchFiltersProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Guests', style: context.textStyle.titleMedium),
            SizedBox(height: context.spacing.s16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  onTap: guest > 1
                      ? () => notifier.update(
                          (state) => state.copyWith(guest: state.guest - 1),
                        )
                      : null,
                ),
                Text('$guest', style: context.textStyle.headlineSmall),
                _StepperButton(
                  icon: Icons.add,
                  onTap: guest < 12
                      ? () => notifier.update(
                          (state) => state.copyWith(guest: state.guest + 1),
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: context.spacing.s24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon, size: 18.sp),
    );
  }
}

class _PriceRangeSheet extends ConsumerWidget {
  const _PriceRangeSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);
    final min = filters.minPrice.round();
    final max = filters.maxPrice.round();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.padding.p20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Price range', style: context.textStyle.titleMedium),
            SizedBox(height: context.spacing.s16),
            Text(
              '৳$min – ৳$max',
              textAlign: TextAlign.center,
              style: context.textStyle.headlineSmall,
            ),
            RangeSlider(
              values: RangeValues(filters.minPrice, filters.maxPrice),
              min: 0,
              max: 10000,
              divisions: 40,
              labels: RangeLabels('$min', '$max'),
              activeColor: context.color.primary,
              onChanged: (values) => notifier.update(
                (state) => state.copyWith(
                  minPrice: values.start,
                  maxPrice: values.end,
                ),
              ),
            ),
            SizedBox(height: context.spacing.s8),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
