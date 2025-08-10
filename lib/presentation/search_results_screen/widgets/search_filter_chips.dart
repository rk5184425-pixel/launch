import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterChips extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;
  final VoidCallback onClearFilters;

  const SearchFilterChips({
    super.key,
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filterOptions = [
      {'label': 'Public Banks', 'value': 'public', 'icon': 'account_balance'},
      {'label': 'Private Banks', 'value': 'private', 'icon': 'business'},
      {'label': 'Credit Cards', 'value': 'credit_card', 'icon': 'credit_card'},
      {'label': 'Loans', 'value': 'loans', 'icon': 'account_balance_wallet'},
      {'label': '24/7 Available', 'value': 'available', 'icon': 'access_time'},
      {'label': 'Emergency', 'value': 'emergency', 'icon': 'emergency'},
    ];

    return Container(
      height: 6.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          // Clear Filters Button
          if (selectedFilters.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Clear (${selectedFilters.length})',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onSelected: (_) => onClearFilters(),
                backgroundColor: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                selectedColor: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.2),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

          // Filter Options
          ...filterOptions.map((filter) {
            final bool isSelected = selectedFilters.contains(filter['value']);
            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: filter['icon'] as String,
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      filter['label'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => onFilterToggle(filter['value'] as String),
                backgroundColor:
                    AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                selectedColor: AppTheme.lightTheme.colorScheme.primary,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
