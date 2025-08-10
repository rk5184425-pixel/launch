import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_version_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_stepper_widget.dart';
import './widgets/settings_switch_widget.dart';
import './widgets/settings_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Calling Preferences
  bool _confirmationDialogs = true;
  bool _autoSpeaker = false;
  String _defaultCallingApp = 'System Default';

  // Notifications
  bool _updateAlerts = true;
  bool _emergencyNotifications = true;
  bool _maintenanceAnnouncements = false;

  // Data Management
  int _syncFrequency = 24; // hours
  bool _accuracyReporting = true;

  // Privacy
  int _callHistoryRetention = 30; // days
  bool _analyticsOptOut = false;
  bool _contactSharing = true;

  // Accessibility
  bool _largeText = false;
  bool _highContrast = false;
  bool _voiceOver = false;

  final List<Map<String, dynamic>> _callingApps = [
    {"name": "System Default", "description": "Use device default dialer"},
    {"name": "Google Phone", "description": "Google's phone application"},
    {"name": "Samsung Phone", "description": "Samsung's native dialer"},
    {"name": "Truecaller", "description": "Enhanced caller identification"},
  ];

  void _showCallingAppSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(maxHeight: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Select Default Calling App',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _callingApps.length,
                itemBuilder: (context, index) {
                  final app = _callingApps[index];
                  final isSelected = _defaultCallingApp == app["name"];

                  return ListTile(
                    leading: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'phone',
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      app["name"] as String,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : null,
                          ),
                    ),
                    subtitle: Text(
                      app["description"] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _defaultCallingApp = app["name"] as String;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
          'This will clear all cached bank contact data. You\'ll need an internet connection to reload the information. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Collection',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'We collect minimal data to provide banking helpline services. This includes call history for your convenience and usage analytics to improve app performance.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Data Usage',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Your data is used solely to enhance your banking support experience. We never share personal information with third parties without explicit consent.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Data Security',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'All data is encrypted and stored securely. Banking contact information is sourced from official bank websites and verified regularly.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Terms of Service',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Usage',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Bank Helpline Hub provides contact information for banking customer service. We are not affiliated with any bank and do not provide banking services directly.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Accuracy Disclaimer',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'While we strive to maintain accurate contact information, banks may change their helpline numbers. Always verify critical information directly with your bank.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'User Responsibilities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Users are responsible for verifying bank contact information and using the app in accordance with their bank\'s terms and conditions.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Calling Preferences Section
            SettingsSectionWidget(
              title: 'CALLING PREFERENCES',
              children: [
                SettingsTileWidget(
                  title: 'Default Calling App',
                  subtitle: _defaultCallingApp,
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  showArrow: true,
                  onTap: _showCallingAppSelector,
                ),
                SettingsSwitchWidget(
                  title: 'Confirmation Dialogs',
                  subtitle: 'Show confirmation before making calls',
                  value: _confirmationDialogs,
                  onChanged: (value) =>
                      setState(() => _confirmationDialogs = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'help_outline',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Auto-Speaker Activation',
                  subtitle: 'Automatically enable speaker during calls',
                  value: _autoSpeaker,
                  onChanged: (value) => setState(() => _autoSpeaker = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'volume_up',
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Notifications Section
            SettingsSectionWidget(
              title: 'NOTIFICATIONS',
              children: [
                SettingsSwitchWidget(
                  title: 'Update Alerts',
                  subtitle: 'Notify when contact information changes',
                  value: _updateAlerts,
                  onChanged: (value) => setState(() => _updateAlerts = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'notifications',
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Emergency Helpline Notifications',
                  subtitle: 'Priority alerts for emergency banking services',
                  value: _emergencyNotifications,
                  onChanged: (value) =>
                      setState(() => _emergencyNotifications = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'emergency',
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Maintenance Announcements',
                  subtitle: 'App updates and maintenance notifications',
                  value: _maintenanceAnnouncements,
                  onChanged: (value) =>
                      setState(() => _maintenanceAnnouncements = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'build',
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Data Management Section
            SettingsSectionWidget(
              title: 'DATA MANAGEMENT',
              children: [
                SettingsStepperWidget(
                  title: 'Offline Data Sync Frequency',
                  subtitle: 'How often to update contact database',
                  value: _syncFrequency,
                  minValue: 6,
                  maxValue: 168,
                  unit: 'hours',
                  onChanged: (value) => setState(() => _syncFrequency = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'sync',
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsTileWidget(
                  title: 'Clear Cache',
                  subtitle: 'Remove stored contact data',
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'delete_outline',
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                  ),
                  onTap: _showClearCacheDialog,
                ),
                SettingsSwitchWidget(
                  title: 'Contact Accuracy Reporting',
                  subtitle: 'Help improve data quality by reporting issues',
                  value: _accuracyReporting,
                  onChanged: (value) =>
                      setState(() => _accuracyReporting = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'report',
                        color: Colors.teal,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Privacy Section
            SettingsSectionWidget(
              title: 'PRIVACY',
              children: [
                SettingsStepperWidget(
                  title: 'Call History Retention',
                  subtitle: 'How long to keep call history',
                  value: _callHistoryRetention,
                  minValue: 7,
                  maxValue: 365,
                  unit: 'days',
                  onChanged: (value) =>
                      setState(() => _callHistoryRetention = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'history',
                        color: Colors.indigo,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Analytics Opt-out',
                  subtitle: 'Disable usage analytics collection',
                  value: _analyticsOptOut,
                  onChanged: (value) =>
                      setState(() => _analyticsOptOut = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.brown.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'analytics',
                        color: Colors.brown,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Contact Sharing Permissions',
                  subtitle: 'Allow sharing bank contacts via messaging apps',
                  value: _contactSharing,
                  onChanged: (value) => setState(() => _contactSharing = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Accessibility Section
            SettingsSectionWidget(
              title: 'ACCESSIBILITY',
              children: [
                SettingsSwitchWidget(
                  title: 'Large Text Support',
                  subtitle: 'Increase text size for better readability',
                  value: _largeText,
                  onChanged: (value) => setState(() => _largeText = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'text_fields',
                        color: Colors.cyan,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'High Contrast Mode',
                  subtitle: 'Enhanced contrast for better visibility',
                  value: _highContrast,
                  onChanged: (value) => setState(() => _highContrast = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'contrast',
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SettingsSwitchWidget(
                  title: 'Voice-over Optimizations',
                  subtitle: 'Enhanced screen reader support',
                  value: _voiceOver,
                  onChanged: (value) => setState(() => _voiceOver = value),
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'accessibility',
                        color: Colors.deepPurple,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // About Section
            SettingsSectionWidget(
              title: 'ABOUT',
              children: [
                SettingsTileWidget(
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'privacy_tip',
                        color: Colors.lightBlue,
                        size: 20,
                      ),
                    ),
                  ),
                  showArrow: true,
                  onTap: _showPrivacyPolicy,
                ),
                SettingsTileWidget(
                  title: 'Terms of Service',
                  subtitle: 'App usage terms and conditions',
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'description',
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                  showArrow: true,
                  onTap: _showTermsOfService,
                ),
              ],
            ),

            // App Version Widget
            AppVersionWidget(),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
