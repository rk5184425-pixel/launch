import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BankCardWidget extends StatelessWidget {
  final Map<String, dynamic> bankData;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;
  final bool isFavorite;

  const BankCardWidget({
    Key? key,
    required this.bankData,
    this.onTap,
    this.onFavoriteToggle,
    this.onShare,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String bankName = bankData['name'] as String? ?? 'Unknown Bank';
    final String helplineNumber = bankData['helpline'] as String? ?? 'N/A';
    final String serviceHours = bankData['serviceHours'] as String? ?? '24/7';
    final String logoUrl = bankData['logoUrl'] as String? ?? '';
    final bool isEmergency = bankData['isEmergency'] as bool? ?? false;
    final String bankType = bankData['type'] as String? ?? 'Private';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Bank Logo
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                      ),
                      child: logoUrl.isNotEmpty
                          ? CustomImageWidget(
                              imageUrl: logoUrl,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.contain,
                            )
                          : Center(
                              child: CustomIconWidget(
                                iconName: 'account_balance',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 6.w,
                              ),
                            ),
                    ),
                    SizedBox(width: 3.w),
                    // Bank Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  bankName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isEmergency)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'EMERGENCY',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onError,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            bankType,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    // Favorite Button
                    IconButton(
                      onPressed: onFavoriteToggle,
                      icon: CustomIconWidget(
                        iconName: isFavorite ? 'favorite' : 'favorite_border',
                        color: isFavorite
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Helpline Number
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        helplineNumber,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                      ),
                    ),
                    // Call Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Handle direct call
                        },
                        icon: CustomIconWidget(
                          iconName: 'call',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 4.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                // Service Hours
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Service Hours: $serviceHours',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const Spacer(),
                    // Share Button
                    IconButton(
                      onPressed: onShare,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
