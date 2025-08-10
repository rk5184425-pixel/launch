import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsStepperWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int value;
  final int minValue;
  final int maxValue;
  final String unit;
  final ValueChanged<int> onChanged;
  final Widget? leading;

  const SettingsStepperWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: 3.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: value > minValue ? () => onChanged(value - 1) : null,
                icon: CustomIconWidget(
                  iconName: 'remove',
                  color: value > minValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 20,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 8.w,
                ),
                padding: EdgeInsets.zero,
              ),
              Container(
                constraints: BoxConstraints(minWidth: 15.w),
                child: Text(
                  '$value $unit',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                onPressed: value < maxValue ? () => onChanged(value + 1) : null,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: value < maxValue
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 20,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 8.w,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
