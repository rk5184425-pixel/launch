import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onBrowseAll;
  final Function(String) onSuggestionTap;

  const NoResultsWidget({
    super.key,
    required this.searchQuery,
    required this.onBrowseAll,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'Chase Bank',
      'Bank of America',
      'Wells Fargo',
      'Credit Card Support',
      'Loan Services',
      'Emergency Banking',
    ];

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // No Results Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 10.w,
              ),
            ),
            SizedBox(height: 4.h),

            // No Results Title
            Text(
              'No results found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),

            // Search Query Display
            if (searchQuery.isNotEmpty)
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'We couldn\'t find any banks matching "',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: searchQuery,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: '"',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 3.h),

            // Suggestions
            Text(
              'Try searching for:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Suggestion Chips
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              alignment: WrapAlignment.center,
              children: suggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () => onSuggestionTap(suggestion),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 4.h),

            // Browse All Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBrowseAll,
                icon: CustomIconWidget(
                  iconName: 'list',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(
                  'Browse All Banks',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
