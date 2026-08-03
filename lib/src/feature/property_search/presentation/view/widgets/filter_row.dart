import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../domain/model/search_filters.dart';
import '../../view_model/search_filters_provider.dart';
import 'filter_sheets.dart';

class FilterRow extends ConsumerWidget {
  const FilterRow({super.key, required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  icon: Icons.calendar_month_outlined,
                  label: _dateLabel(filters),
                  onTap: () => _pickDates(context, ref, filters),
                ),
                SizedBox(width: context.spacing.s8),
                _FilterChip(
                  icon: Icons.person_outline,
                  label: '${filters.guest} guests',
                  onTap: () => showGuestPickerSheet(context),
                ),
                SizedBox(width: context.spacing.s8),
                _FilterChip(
                  icon: Icons.currency_exchange,
                  label: filters.priceLabel,
                  onTap: () => showPriceRangeSheet(context),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: context.spacing.s8),
        FilledButton.icon(
          onPressed: onSearch,
          style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
          icon: const Icon(Icons.search),
          label: const Text('Search'),
        ),
      ],
    );
  }

  String _dateLabel(SearchFilters filters) {
    final from = filters.from;
    final to = filters.to;
    if (from == null) return 'Add dates';
    if (to == null) return '${_short(from)} → ?';
    return '${_short(from)} → ${_short(to)}';
  }

  String _short(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month-$day';
  }

  Future<void> _pickDates(
    BuildContext context,
    WidgetRef ref,
    SearchFilters filters,
  ) async {
    final now = DateTime.now();
    final from = await showDatePicker(
      context: context,
      initialDate: filters.from ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Select check-in',
    );
    if (from == null || !context.mounted) return;
    final to = await showDatePicker(
      context: context,
      initialDate: filters.to ?? from.add(const Duration(days: 1)),
      firstDate: from.add(const Duration(days: 1)),
      lastDate: from.add(const Duration(days: 365)),
      helpText: 'Select check-out',
    );
    if (to == null) return;
    ref
        .read(searchFiltersProvider.notifier)
        .update((state) => state.copyWith(from: from, to: to));
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.textFieldFillColor,
      borderRadius: BorderRadius.circular(context.radius.r12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radius.r12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.s12,
            vertical: context.spacing.s8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.radius.r12),
            border: Border.all(
              color: context.color.border.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16.sp, color: context.color.primary),
              SizedBox(width: context.spacing.s6),
              Text(label, style: context.textStyle.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
