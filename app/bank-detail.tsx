import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  Linking,
  Share,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import {
  ArrowLeft,
  Phone,
  Mail,
  MessageCircle,
  MapPin,
  Share2,
  Clock,
  AlertTriangle,
} from 'lucide-react-native';
import { colors, typography, spacing, borderRadius, shadows } from '../src/constants/theme';
import Toast from 'react-native-toast-message';

export default function BankDetailScreen() {
  const params = useLocalSearchParams();
  const [activeTab, setActiveTab] = useState<'phone' | 'email' | 'chat' | 'location'>('phone');

  // Mock bank data - in real app, this would come from params or API
  const bankData = {
    id: params.bankId || '1',
    name: 'Chase Bank',
    type: 'Private',
    logoUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&h=200&fit=crop',
    primaryHelpline: '1-800-935-9935',
    emergencyHelpline: '1-800-242-7338',
    isEmergency: true,
    phoneNumbers: [
      {
        type: 'General Customer Service',
        number: '1-800-935-9935',
        hours: '24/7 Available',
        icon: 'phone'
      },
      {
        type: 'Credit Card Support',
        number: '1-800-432-3117',
        hours: 'Mon-Fri 8AM-10PM EST',
        icon: 'credit-card'
      },
      {
        type: 'Mortgage Services',
        number: '1-800-848-9136',
        hours: 'Mon-Fri 7AM-10PM EST',
        icon: 'home'
      }
    ],
    emailSupport: [
      {
        type: 'General Inquiries',
        email: 'customer.service@chase.com',
        description: 'For general banking questions and account inquiries'
      },
      {
        type: 'Credit Card Issues',
        email: 'creditcard.support@chase.com',
        description: 'For credit card related concerns and disputes'
      }
    ],
    chatSupport: [
      {
        type: 'Live Chat Support',
        url: 'https://www.chase.com/digital/customer-service',
        availability: 'Available 24/7',
        isActive: true
      },
      {
        type: 'Facebook Messenger',
        url: 'https://m.me/chase',
        availability: 'Mon-Fri 8AM-8PM EST',
        isActive: true
      }
    ]
  };

  const handleCall = (phoneNumber: string) => {
    Alert.alert(
      'Call Bank',
      `Do you want to call ${phoneNumber}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Call', 
          onPress: () => {
            Linking.openURL(`tel:${phoneNumber}`);
            Toast.show({
              type: 'success',
              text1: `Calling ${bankData.name}...`,
            });
          }
        }
      ]
    );
  };

  const handleEmail = (email: string) => {
    Linking.openURL(`mailto:${email}?subject=Banking Inquiry`);
  };

  const handleChat = (url: string) => {
    Linking.openURL(url);
  };

  const handleShare = async () => {
    try {
      await Share.share({
        message: `${bankData.name}\nHelpline: ${bankData.primaryHelpline}\nEmergency: ${bankData.emergencyHelpline}`,
        title: `${bankData.name} Contact Details`,
      });
    } catch (error) {
      Toast.show({
        type: 'error',
        text1: 'Failed to share contact details',
      });
    }
  };

  const handleMaps = () => {
    const query = encodeURIComponent(`${bankData.name} near me`);
    const url = `https://www.google.com/maps/search/${query}`;
    Linking.openURL(url);
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'phone':
        return (
          <View style={styles.tabContent}>
            {bankData.phoneNumbers.map((contact, index) => (
              <TouchableOpacity
                key={index}
                style={styles.contactCard}
                onPress={() => handleCall(contact.number)}
              >
                <View style={styles.contactIcon}>
                  <Phone size={20} color={colors.primary} />
                </View>
                <View style={styles.contactInfo}>
                  <Text style={styles.contactType}>{contact.type}</Text>
                  <Text style={styles.contactNumber}>{contact.number}</Text>
                  <View style={styles.hoursRow}>
                    <Clock size={14} color={colors.onSurfaceVariant} />
                    <Text style={styles.contactHours}>{contact.hours}</Text>
                  </View>
                </View>
                <View style={styles.callButton}>
                  <Phone size={16} color={colors.onPrimary} />
                </View>
              </TouchableOpacity>
            ))}
          </View>
        );

      case 'email':
        return (
          <View style={styles.tabContent}>
            {bankData.emailSupport.map((email, index) => (
              <TouchableOpacity
                key={index}
                style={styles.contactCard}
                onPress={() => handleEmail(email.email)}
              >
                <View style={styles.contactIcon}>
                  <Mail size={20} color={colors.secondary} />
                </View>
                <View style={styles.contactInfo}>
                  <Text style={styles.contactType}>{email.type}</Text>
                  <Text style={styles.contactNumber}>{email.email}</Text>
                  <Text style={styles.contactDescription}>{email.description}</Text>
                </View>
                <ArrowLeft size={16} color={colors.onSurfaceVariant} style={{ transform: [{ rotate: '180deg' }] }} />
              </TouchableOpacity>
            ))}
          </View>
        );

      case 'chat':
        return (
          <View style={styles.tabContent}>
            {bankData.chatSupport.map((chat, index) => (
              <TouchableOpacity
                key={index}
                style={[styles.contactCard, !chat.isActive && styles.inactiveCard]}
                onPress={() => chat.isActive && handleChat(chat.url)}
                disabled={!chat.isActive}
              >
                <View style={styles.contactIcon}>
                  <MessageCircle size={20} color={chat.isActive ? colors.secondary : colors.onSurfaceVariant} />
                </View>
                <View style={styles.contactInfo}>
                  <View style={styles.chatHeader}>
                    <Text style={[styles.contactType, !chat.isActive && styles.inactiveText]}>
                      {chat.type}
                    </Text>
                    {chat.isActive && (
                      <View style={styles.onlineBadge}>
                        <Text style={styles.onlineText}>ONLINE</Text>
                      </View>
                    )}
                  </View>
                  <Text style={[styles.contactDescription, !chat.isActive && styles.inactiveText]}>
                    {chat.availability}
                  </Text>
                </View>
                <ArrowLeft size={16} color={colors.onSurfaceVariant} style={{ transform: [{ rotate: '180deg' }] }} />
              </TouchableOpacity>
            ))}
          </View>
        );

      case 'location':
        return (
          <View style={styles.tabContent}>
            <View style={styles.locationContent}>
              <View style={styles.locationIcon}>
                <MapPin size={48} color={colors.primary} />
              </View>
              <Text style={styles.locationTitle}>Find Nearby Branches</Text>
              <Text style={styles.locationDescription}>
                Locate the nearest {bankData.name} branch or ATM using Google Maps
              </Text>
              <TouchableOpacity style={styles.mapsButton} onPress={handleMaps}>
                <MapPin size={20} color={colors.onPrimary} />
                <Text style={styles.mapsButtonText}>Open in Maps</Text>
              </TouchableOpacity>
            </View>
          </View>
        );

      default:
        return null;
    }
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <ArrowLeft size={24} color={colors.onSurface} />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>{bankData.name}</Text>
        <TouchableOpacity onPress={handleShare} style={styles.shareButton}>
          <Share2 size={24} color={colors.onSurface} />
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Bank Hero Section */}
        <View style={styles.heroSection}>
          <View style={styles.bankLogo}>
            <Phone size={40} color={colors.primary} />
          </View>
          <Text style={styles.bankName}>{bankData.name}</Text>
          <Text style={styles.bankSubtitle}>Customer Service</Text>

          {/* Primary Helpline */}
          <TouchableOpacity
            style={styles.primaryHelpline}
            onPress={() => handleCall(bankData.primaryHelpline)}
          >
            <Text style={styles.helplineLabel}>Primary Helpline</Text>
            <View style={styles.helplineRow}>
              <Phone size={24} color={colors.onPrimary} />
              <Text style={styles.helplineNumber}>{bankData.primaryHelpline}</Text>
            </View>
            <Text style={styles.helplineSubtext}>Tap to call now</Text>
          </TouchableOpacity>

          {/* Emergency Helpline */}
          <TouchableOpacity
            style={styles.emergencyHelpline}
            onPress={() => handleCall(bankData.emergencyHelpline)}
          >
            <AlertTriangle size={20} color={colors.error} />
            <View style={styles.emergencyInfo}>
              <Text style={styles.emergencyText}>Emergency: {bankData.emergencyHelpline}</Text>
              <Text style={styles.emergencySubtext}>24/7 Available</Text>
            </View>
          </TouchableOpacity>
        </View>

        {/* Tab Navigation */}
        <View style={styles.tabContainer}>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'phone' && styles.activeTab]}
            onPress={() => setActiveTab('phone')}
          >
            <Phone size={16} color={activeTab === 'phone' ? colors.onPrimary : colors.primary} />
            <Text style={[styles.tabText, activeTab === 'phone' && styles.activeTabText]}>Phone</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'email' && styles.activeTab]}
            onPress={() => setActiveTab('email')}
          >
            <Mail size={16} color={activeTab === 'email' ? colors.onPrimary : colors.primary} />
            <Text style={[styles.tabText, activeTab === 'email' && styles.activeTabText]}>Email</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'chat' && styles.activeTab]}
            onPress={() => setActiveTab('chat')}
          >
            <MessageCircle size={16} color={activeTab === 'chat' ? colors.onPrimary : colors.primary} />
            <Text style={[styles.tabText, activeTab === 'chat' && styles.activeTabText]}>Chat</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, activeTab === 'location' && styles.activeTab]}
            onPress={() => setActiveTab('location')}
          >
            <MapPin size={16} color={activeTab === 'location' ? colors.onPrimary : colors.primary} />
            <Text style={[styles.tabText, activeTab === 'location' && styles.activeTabText]}>Locate</Text>
          </TouchableOpacity>
        </View>

        {/* Tab Content */}
        {renderTabContent()}
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
  shareButton: {
    padding: spacing.sm,
  },
  content: {
    flex: 1,
  },
  heroSection: {
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.xl,
    backgroundColor: colors.surface,
  },
  bankLogo: {
    width: 80,
    height: 80,
    backgroundColor: colors.onPrimary,
    borderRadius: borderRadius.lg,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.lg,
    ...shadows.md,
  },
  bankName: {
    ...typography.headlineSmall,
    color: colors.onSurface,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: spacing.sm,
  },
  bankSubtitle: {
    ...typography.bodyMedium,
    color: colors.onSurfaceVariant,
    marginBottom: spacing.xl,
  },
  primaryHelpline: {
    width: '100%',
    backgroundColor: colors.primary,
    borderRadius: borderRadius.lg,
    padding: spacing.lg,
    alignItems: 'center',
    marginBottom: spacing.md,
    ...shadows.lg,
  },
  helplineLabel: {
    ...typography.titleMedium,
    color: colors.onPrimary,
    fontWeight: '500',
    marginBottom: spacing.sm,
  },
  helplineRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  helplineNumber: {
    ...typography.headlineSmall,
    color: colors.onPrimary,
    fontWeight: '700',
    marginLeft: spacing.sm,
  },
  helplineSubtext: {
    ...typography.bodySmall,
    color: colors.onPrimary,
    opacity: 0.8,
  },
  emergencyHelpline: {
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.error,
    borderRadius: borderRadius.lg,
    padding: spacing.md,
  },
  emergencyInfo: {
    marginLeft: spacing.sm,
  },
  emergencyText: {
    ...typography.titleSmall,
    color: colors.error,
    fontWeight: '600',
  },
  emergencySubtext: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
  },
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: colors.surfaceVariant,
    marginHorizontal: spacing.md,
    borderRadius: borderRadius.lg,
    padding: 4,
    marginVertical: spacing.md,
  },
  tab: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.lg,
  },
  activeTab: {
    backgroundColor: colors.primary,
  },
  tabText: {
    ...typography.labelMedium,
    color: colors.primary,
    marginLeft: spacing.xs,
    fontWeight: '500',
  },
  activeTabText: {
    color: colors.onPrimary,
  },
  tabContent: {
    paddingHorizontal: spacing.md,
    paddingBottom: spacing.xl,
  },
  contactCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    padding: spacing.md,
    marginBottom: spacing.sm,
    ...shadows.sm,
  },
  inactiveCard: {
    opacity: 0.6,
  },
  contactIcon: {
    width: 48,
    height: 48,
    backgroundColor: colors.surfaceVariant,
    borderRadius: borderRadius.md,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: spacing.md,
  },
  contactInfo: {
    flex: 1,
  },
  contactType: {
    ...typography.titleMedium,
    color: colors.onSurface,
    fontWeight: '600',
    marginBottom: spacing.xs,
  },
  contactNumber: {
    ...typography.bodyLarge,
    color: colors.primary,
    fontWeight: '500',
    marginBottom: spacing.xs,
  },
  contactDescription: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
  },
  contactHours: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
    marginLeft: spacing.xs,
  },
  hoursRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  callButton: {
    width: 40,
    height: 40,
    backgroundColor: colors.secondary,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  chatHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.xs,
  },
  onlineBadge: {
    backgroundColor: colors.secondary,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    borderRadius: borderRadius.lg,
    marginLeft: spacing.sm,
  },
  onlineText: {
    ...typography.labelSmall,
    color: colors.onPrimary,
    fontWeight: '600',
  },
  inactiveText: {
    color: colors.onSurfaceVariant,
  },
  locationContent: {
    alignItems: 'center',
    paddingVertical: spacing.xl,
  },
  locationIcon: {
    marginBottom: spacing.lg,
  },
  locationTitle: {
    ...typography.headlineSmall,
    color: colors.onSurface,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: spacing.md,
  },
  locationDescription: {
    ...typography.bodyMedium,
    color: colors.onSurfaceVariant,
    textAlign: 'center',
    marginBottom: spacing.xl,
  },
  mapsButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.primary,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderRadius: borderRadius.lg,
  },
  mapsButtonText: {
    ...typography.labelLarge,
    color: colors.onPrimary,
    fontWeight: '600',
    marginLeft: spacing.sm,
  },
});