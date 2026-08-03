import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/static/theme/theme.dart';
import '../../../data/model/location.dart';
import '../../view_model/location_search_provider.dart';
import '../../view_model/location_search_state.dart';

class LocationSearchField extends ConsumerStatefulWidget {
  const LocationSearchField({super.key});

  @override
  ConsumerState<LocationSearchField> createState() =>
      _LocationSearchFieldState();
}

class _LocationSearchFieldState extends ConsumerState<LocationSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(locationSearchViewModelProvider).selected?.name ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(locationSearchViewModelProvider);
    final notifier = ref.read(locationSearchViewModelProvider.notifier);

    ref.listen<LocationSearchState>(locationSearchViewModelProvider, (
      prev,
      next,
    ) {
      if (next.selected != null && next.selected != prev?.selected) {
        _controller.text = next.selected!.name;
      }
    });

    return TapRegionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.color.scaffoldBackground,
              borderRadius: BorderRadius.circular(context.radius.r16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              onChanged: notifier.onQueryChanged,
              onTapOutside: (_) => notifier.clearSuggestions(),
              textInputAction: TextInputAction.search,
              style: context.textStyle.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Where are you going?',
                prefixIcon: Icon(Icons.search, color: context.color.primary),
                suffixIcon: searchState.isLoading
                    ? Padding(
                        padding: EdgeInsets.all(12.r),
                        child: SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.color.primary,
                          ),
                        ),
                      )
                    : null,
                filled: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (searchState.suggestions.isNotEmpty)
            TapRegion(
              groupId: EditableText,
              child: _SuggestionDropdown(
                locations: searchState.suggestions,
                onSelected: notifier.select,
              ),
            ),
        ],
      ),
    );
  }
}

class _SuggestionDropdown extends StatelessWidget {
  const _SuggestionDropdown({
    required this.locations,
    required this.onSelected,
  });

  final List<Location> locations;
  final ValueChanged<Location> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(context.radius.r12),
      color: context.color.textFieldFillColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 260.h),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: context.spacing.s4),
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return ListTile(
              dense: true,
              leading: Icon(
                Icons.place_outlined,
                size: 18.sp,
                color: context.color.primary,
              ),
              title: Text(location.name, style: context.textStyle.bodyMedium),
              subtitle: location.nameBn == null
                  ? null
                  : Text(
                      location.nameBn!,
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.text.secondary,
                      ),
                    ),
              onTap: () => onSelected(location),
            );
          },
        ),
      ),
    );
  }
}
