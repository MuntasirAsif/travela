import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../view_model/search_filters_provider.dart';

void showGuestPickerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: context.color.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.radius.r24),
      ),
    ),
    builder: (_) => const _GuestPickerSheet(),
  );
}

void showPriceRangeSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: context.color.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.radius.r24),
      ),
    ),
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
        padding: EdgeInsets.fromLTRB(
          context.padding.p24,
          context.padding.p8,
          context.padding.p24,
          context.padding.p24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Who\'s coming?',
              style: context.textStyle.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.spacing.s24),
            Container(
              padding: EdgeInsets.all(context.spacing.s16),
              decoration: BoxDecoration(
                color: context.color.textFieldFillColor,
                borderRadius: BorderRadius.circular(context.radius.r16),
                border: Border.all(
                  color: context.color.border.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guests', style: context.textStyle.titleMedium),
                      SizedBox(height: context.spacing.s4),
                      Text(
                        'Ages 2 or above',
                        style: context.textStyle.bodySmall.copyWith(
                          color: context.color.text.secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _StepperButton(
                        icon: Icons.remove,
                        onTap: guest > 1
                            ? () => notifier.update(
                                (state) =>
                                    state.copyWith(guest: state.guest - 1),
                              )
                            : null,
                      ),
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          '$guest',
                          textAlign: TextAlign.center,
                          style: context.textStyle.titleLarge,
                        ),
                      ),
                      _StepperButton(
                        icon: Icons.add,
                        onTap: guest < 12
                            ? () => notifier.update(
                                (state) =>
                                    state.copyWith(guest: state.guest + 1),
                              )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.s32),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius.r16),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
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
    final isDisabled = onTap == null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: EdgeInsets.all(context.spacing.s8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDisabled
                  ? context.color.border.withValues(alpha: 0.3)
                  : context.color.primary.withValues(alpha: 0.5),
            ),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: isDisabled ? context.color.disabled : context.color.primary,
          ),
        ),
      ),
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
        padding: EdgeInsets.fromLTRB(
          context.padding.p24,
          context.padding.p8,
          context.padding.p24,
          context.padding.p24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Price range',
              style: context.textStyle.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.spacing.s8),
            Text(
              'Nightly prices before fees and taxes',
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
            ),
            SizedBox(height: context.spacing.s32),
            Row(
              children: [
                Expanded(
                  child: _PriceDisplayBox(label: 'Minimum', price: '৳$min'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.s12,
                  ),
                  child: Text(
                    '–',
                    style: context.textStyle.titleLarge.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ),
                Expanded(
                  child: _PriceDisplayBox(
                    label: 'Maximum',
                    price: max == 10000 ? '৳$max+' : '৳$max',
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.s24),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: context.color.primary,
                inactiveTrackColor: context.color.primary.withValues(
                  alpha: 0.2,
                ),
                thumbColor: context.color.primary,
                overlayColor: context.color.primary.withValues(alpha: 0.1),
                trackHeight: 4,
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 14,
                  elevation: 4,
                ),
              ),
              child: RangeSlider(
                values: RangeValues(filters.minPrice, filters.maxPrice),
                min: 0,
                max: 10000,
                divisions: 100,
                onChanged: (values) => notifier.update(
                  (state) => state.copyWith(
                    minPrice: values.start,
                    maxPrice: values.end,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.spacing.s32),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radius.r16),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceDisplayBox extends StatelessWidget {
  const _PriceDisplayBox({required this.label, required this.price});

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.s16,
        vertical: context.spacing.s12,
      ),
      decoration: BoxDecoration(
        color: context.color.textFieldFillColor,
        borderRadius: BorderRadius.circular(context.radius.r16),
        border: Border.all(color: context.color.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyle.labelSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
          SizedBox(height: context.spacing.s4),
          Text(price, style: context.textStyle.titleMedium),
        ],
      ),
    );
  }
}
