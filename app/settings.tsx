import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  Alert,
} from 'react-native';
import { router } from 'expo-router';
import {
  ArrowLeft,
  Phone,
  Bell,
  Database,
  Shield,
  Eye,
  Info,
  ChevronRight,
  Plus,
  Minus,
} from 'lucide-react-native';
import { colors, typography, spacing, borderRadius, shadows } from '../src/constants/theme';
import Toast from 'react-native-toast-message';

interface SettingsSectionProps {
  title: string;
  children: React.ReactNode;
}

interface SettingsTileProps {
  title: string;
  subtitle?: string;
  icon: React.ReactNode;
  onPress?: () => void;
  showArrow?: boolean;
}

interface SettingsSwitchProps {
  title: string;
  subtitle?: string;
  icon: React.ReactNode;
  value: boolean;
  onValueChange: (value: boolean) => void;
}

interface SettingsStepperProps {
  title: string;
  subtitle?: string;
  icon: React.ReactNode;
  value: number;
  minValue: number;
  maxValue: number;
  unit: string;
  onValueChange: (value: number) => void;
}

function SettingsSection({ title, children }: SettingsSectionProps) {
  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{title}</Text>
      <View style={styles.sectionContent}>
        {children}
      </View>
    </View>
  );
}

function SettingsTile({ title, subtitle, icon, onPress, showArrow = false }: SettingsTileProps) {
  return (
    <TouchableOpacity style={styles.settingItem} onPress={onPress}>
      <View style={styles.settingIcon}>{icon}</View>
      <View style={styles.settingContent}>
        <Text style={styles.settingTitle}>{title}</Text>
        {subtitle && <Text style={styles.settingSubtitle}>{subtitle}</Text>}
      </View>
      {showArrow && <ChevronRight size={20} color={colors.onSurfaceVariant} />}
    </TouchableOpacity>
  );
}

function SettingsSwitch({ title, subtitle, icon, value, onValueChange }: SettingsSwitchProps) {
  return (
    <View style={styles.settingItem}>
      <View style={styles.settingIcon}>{icon}</View>
      <View style={styles.settingContent}>
        <Text style={styles.settingTitle}>{title}</Text>
        {subtitle && <Text style={styles.settingSubtitle}>{subtitle}</Text>}
      </View>
      <Switch
        value={value}
        onValueChange={onValueChange}
        trackColor={{ false: colors.outline, true: colors.primary }}
        thumbColor={value ? colors.onPrimary : colors.onSurfaceVariant}
      />
    </View>
  );
}

function SettingsStepper({ title, subtitle, icon, value, minValue, maxValue, unit, onValueChange }: SettingsStepperProps) {
  return (
    <View style={styles.settingItem}>
      <View style={styles.settingIcon}>{icon}</View>
      <View style={styles.settingContent}>
        <Text style={styles.settingTitle}>{title}</Text>
        {subtitle && <Text style={styles.settingSubtitle}>{subtitle}</Text>}
      </View>
      <View style={styles.stepperContainer}>
        <TouchableOpacity
          style={[styles.stepperButton, value <= minValue && styles.stepperButtonDisabled]}
          onPress={() => value > minValue && onValueChange(value - 1)}
          disabled={value <= minValue}
        >
          <Minus size={16} color={value > minValue ? colors.primary : colors.onSurfaceVariant} />
        </TouchableOpacity>
        <Text style={styles.stepperValue}>{value} {unit}</Text>
        <TouchableOpacity
          style={[styles.stepperButton, value >= maxValue && styles.stepperButtonDisabled]}
          onPress={() => value < maxValue && onValueChange(value + 1)}
          disabled={value >= maxValue}
        >
          <Plus size={16} color={value < maxValue ? colors.primary : colors.onSurfaceVariant} />
        </TouchableOpacity>
      </View>
    </View>
  );
}

export default function SettingsScreen() {
  // Calling Preferences
  const [confirmationDialogs, setConfirmationDialogs] = useState(true);
  const [autoSpeaker, setAutoSpeaker] = useState(false);

  // Notifications
  const [updateAlerts, setUpdateAlerts] = useState(true);
  const [emergencyNotifications, setEmergencyNotifications] = useState(true);
  const [maintenanceAnnouncements, setMaintenanceAnnouncements] = useState(false);

  // Data Management
  const [syncFrequency, setSyncFrequency] = useState(24);
  const [accuracyReporting, setAccuracyReporting] = useState(true);

  // Privacy
  const [callHistoryRetention, setCallHistoryRetention] = useState(30);
  const [analyticsOptOut, setAnalyticsOptOut] = useState(false);
  const [contactSharing, setContactSharing] = useState(true);

  // Accessibility
  const [largeText, setLargeText] = useState(false);
  const [highContrast, setHighContrast] = useState(false);
  const [voiceOver, setVoiceOver] = useState(false);

  const showCallingAppSelector = () => {
    Alert.alert(
      'Default Calling App',
      'Choose your preferred calling application',
      [
        { text: 'System Default', onPress: () => Toast.show({ type: 'success', text1: 'System Default selected' }) },
        { text: 'Google Phone', onPress: () => Toast.show({ type: 'success', text1: 'Google Phone selected' }) },
        { text: 'Cancel', style: 'cancel' }
      ]
    );
  };

  const showClearCacheDialog = () => {
    Alert.alert(
      'Clear Cache',
      'This will clear all cached bank contact data. You\'ll need an internet connection to reload the information. Continue?',
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Clear', 
          onPress: () => Toast.show({ type: 'success', text1: 'Cache cleared successfully' })
        }
      ]
    );
  };

  const showPrivacyPolicy = () => {
    Alert.alert(
      'Privacy Policy',
      'We collect minimal data to provide banking helpline services. Your privacy is our priority.',
      [{ text: 'OK' }]
    );
  };

  const showTermsOfService = () => {
    Alert.alert(
      'Terms of Service',
      'Bank Helpline Hub provides contact information for banking customer service. We are not affiliated with any bank.',
      [{ text: 'OK' }]
    );
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <ArrowLeft size={24} color={colors.onSurface} />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Settings</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Calling Preferences */}
        <SettingsSection title="CALLING PREFERENCES">
          <SettingsTile
            title="Default Calling App"
            subtitle="System Default"
            icon={<Phone size={20} color={colors.primary} />}
            onPress={showCallingAppSelector}
            showArrow
          />
          <SettingsSwitch
            title="Confirmation Dialogs"
            subtitle="Show confirmation before making calls"
            icon={<Phone size={20} color={colors.secondary} />}
            value={confirmationDialogs}
            onValueChange={setConfirmationDialogs}
          />
          <SettingsSwitch
            title="Auto-Speaker Activation"
            subtitle="Automatically enable speaker during calls"
            icon={<Phone size={20} color={colors.warning} />}
            value={autoSpeaker}
            onValueChange={setAutoSpeaker}
          />
        </SettingsSection>

        {/* Notifications */}
        <SettingsSection title="NOTIFICATIONS">
          <SettingsSwitch
            title="Update Alerts"
            subtitle="Notify when contact information changes"
            icon={<Bell size={20} color={colors.primary} />}
            value={updateAlerts}
            onValueChange={setUpdateAlerts}
          />
          <SettingsSwitch
            title="Emergency Helpline Notifications"
            subtitle="Priority alerts for emergency banking services"
            icon={<Bell size={20} color={colors.error} />}
            value={emergencyNotifications}
            onValueChange={setEmergencyNotifications}
          />
          <SettingsSwitch
            title="Maintenance Announcements"
            subtitle="App updates and maintenance notifications"
            icon={<Bell size={20} color={colors.onSurfaceVariant} />}
            value={maintenanceAnnouncements}
            onValueChange={setMaintenanceAnnouncements}
          />
        </SettingsSection>

        {/* Data Management */}
        <SettingsSection title="DATA MANAGEMENT">
          <SettingsStepper
            title="Offline Data Sync Frequency"
            subtitle="How often to update contact database"
            icon={<Database size={20} color={colors.success} />}
            value={syncFrequency}
            minValue={6}
            maxValue={168}
            unit="hours"
            onValueChange={setSyncFrequency}
          />
          <SettingsTile
            title="Clear Cache"
            subtitle="Remove stored contact data"
            icon={<Database size={20} color={colors.warning} />}
            onPress={showClearCacheDialog}
          />
          <SettingsSwitch
            title="Contact Accuracy Reporting"
            subtitle="Help improve data quality by reporting issues"
            icon={<Database size={20} color={colors.secondary} />}
            value={accuracyReporting}
            onValueChange={setAccuracyReporting}
          />
        </SettingsSection>

        {/* Privacy */}
        <SettingsSection title="PRIVACY">
          <SettingsStepper
            title="Call History Retention"
            subtitle="How long to keep call history"
            icon={<Shield size={20} color={colors.primary} />}
            value={callHistoryRetention}
            minValue={7}
            maxValue={365}
            unit="days"
            onValueChange={setCallHistoryRetention}
          />
          <SettingsSwitch
            title="Analytics Opt-out"
            subtitle="Disable usage analytics collection"
            icon={<Shield size={20} color={colors.warning} />}
            value={analyticsOptOut}
            onValueChange={setAnalyticsOptOut}
          />
          <SettingsSwitch
            title="Contact Sharing Permissions"
            subtitle="Allow sharing bank contacts via messaging apps"
            icon={<Shield size={20} color={colors.secondary} />}
            value={contactSharing}
            onValueChange={setContactSharing}
          />
        </SettingsSection>

        {/* Accessibility */}
        <SettingsSection title="ACCESSIBILITY">
          <SettingsSwitch
            title="Large Text Support"
            subtitle="Increase text size for better readability"
            icon={<Eye size={20} color={colors.primary} />}
            value={largeText}
            onValueChange={setLargeText}
          />
          <SettingsSwitch
            title="High Contrast Mode"
            subtitle="Enhanced contrast for better visibility"
            icon={<Eye size={20} color={colors.warning} />}
            value={highContrast}
            onValueChange={setHighContrast}
          />
          <SettingsSwitch
            title="Voice-over Optimizations"
            subtitle="Enhanced screen reader support"
            icon={<Eye size={20} color={colors.secondary} />}
            value={voiceOver}
            onValueChange={setVoiceOver}
          />
        </SettingsSection>

        {/* About */}
        <SettingsSection title="ABOUT">
          <SettingsTile
            title="Privacy Policy"
            subtitle="How we handle your data"
            icon={<Info size={20} color={colors.primary} />}
            onPress={showPrivacyPolicy}
            showArrow
          />
          <SettingsTile
            title="Terms of Service"
            subtitle="App usage terms and conditions"
            icon={<Info size={20} color={colors.secondary} />}
            onPress={showTermsOfService}
            showArrow
          />
        </SettingsSection>

        {/* App Version */}
        <View style={styles.versionContainer}>
          <View style={styles.appIcon}>
            <Phone size={32} color={colors.primary} />
          </View>
          <Text style={styles.appName}>Bank Helpline Hub</Text>
          <Text style={styles.appVersion}>Version 2.1.4</Text>
          <Text style={styles.appDate}>Last Updated: August 9, 2025</Text>
          <Text style={styles.appDescription}>
            Your trusted companion for banking customer service access
          </Text>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: spacing.md,
    paddingTop: spacing.xl + 20,
    paddingBottom: spacing.md,
    backgroundColor: colors.surface,
  },
  backButton: {
    padding: spacing.sm,
  },
  headerTitle: {
    ...typography.titleLarge,
    color: colors.onSurface,
    fontWeight: '600',
  },
  placeholder: {
    width: 40,
  },
  content: {
    flex: 1,
    paddingHorizontal: spacing.md,
  },
  section: {
    marginVertical: spacing.md,
  },
  sectionTitle: {
    ...typography.titleSmall,
    color: colors.primary,
    fontWeight: '600',
    marginBottom: spacing.sm,
    paddingHorizontal: spacing.sm,
  },
  sectionContent: {
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
    ...shadows.sm,
  },
  settingItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
    borderBottomColor: colors.outline,
  },
  settingIcon: {
    width: 40,
    height: 40,
    backgroundColor: colors.surfaceVariant,
    borderRadius: borderRadius.md,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  settingContent: {
    flex: 1,
  },
  settingTitle: {
    ...typography.bodyLarge,
    color: colors.onSurface,
    fontWeight: '500',
  },
  settingSubtitle: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
    marginTop: 2,
  },
  stepperContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  stepperButton: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: colors.surfaceVariant,
    justifyContent: 'center',
    alignItems: 'center',
  },
  stepperButtonDisabled: {
    opacity: 0.5,
  },
  stepperValue: {
    ...typography.bodyMedium,
    color: colors.onSurface,
    fontWeight: '600',
    marginHorizontal: spacing.md,
    minWidth: 80,
    textAlign: 'center',
  },
  versionContainer: {
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    marginVertical: spacing.lg,
    ...shadows.sm,
  },
  appIcon: {
    width: 80,
    height: 80,
    backgroundColor: colors.surfaceVariant,
    borderRadius: borderRadius.lg,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  appName: {
    ...typography.titleLarge,
    color: colors.onSurface,
    fontWeight: '600',
    marginBottom: spacing.sm,
  },
  appVersion: {
    ...typography.bodyMedium,
    color: colors.onSurfaceVariant,
    marginBottom: spacing.xs,
  },
  appDate: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
    marginBottom: spacing.md,
  },
  appDescription: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
    textAlign: 'center',
    fontStyle: 'italic',
  },
});