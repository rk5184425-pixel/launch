import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
} from 'react-native';
import {
  Phone,
  Clock,
  Share,
  Heart,
  Building2,
  AlertTriangle,
} from 'lucide-react-native';
import { Bank } from '../types/bank';
import { colors, typography, spacing, borderRadius, shadows } from '../constants/theme';

interface BankCardProps {
  bank: Bank;
  isFavorite?: boolean;
  onPress: () => void;
  onCall: () => void;
  onFavoriteToggle: () => void;
  onShare: () => void;
}

export default function BankCard({
  bank,
  isFavorite = false,
  onPress,
  onCall,
  onFavoriteToggle,
  onShare,
}: BankCardProps) {
  const getBankTypeColor = (type: string) => {
    switch (type.toLowerCase()) {
      case 'public':
        return colors.secondary;
      case 'private':
        return colors.primary;
      case 'cooperative':
        return '#FF9800';
      case 'foreign':
        return '#9C27B0';
      default:
        return colors.primary;
    }
  };

  return (
    <TouchableOpacity style={styles.container} onPress={onPress} activeOpacity={0.7}>
      <View style={styles.content}>
        <View style={styles.header}>
          <View style={styles.logoContainer}>
            {bank.logoUrl ? (
              <Image source={{ uri: bank.logoUrl }} style={styles.logo} />
            ) : (
              <View style={styles.logoPlaceholder}>
                <Building2 size={24} color={colors.primary} />
              </View>
            )}
          </View>
          
          <View style={styles.bankInfo}>
            <View style={styles.nameRow}>
              <Text style={styles.bankName} numberOfLines={1}>
                {bank.name}
              </Text>
              {bank.isEmergency && (
                <View style={styles.emergencyBadge}>
                  <AlertTriangle size={12} color={colors.onPrimary} />
                  <Text style={styles.emergencyText}>EMERGENCY</Text>
                </View>
              )}
            </View>
            <Text style={styles.bankType}>{bank.type}</Text>
          </View>
          
          <TouchableOpacity onPress={onFavoriteToggle} style={styles.favoriteButton}>
            <Heart
              size={20}
              color={isFavorite ? colors.error : colors.onSurfaceVariant}
              fill={isFavorite ? colors.error : 'transparent'}
            />
          </TouchableOpacity>
        </View>

        <View style={styles.contactRow}>
          <Phone size={16} color={colors.primary} />
          <Text style={styles.helplineNumber}>{bank.helpline}</Text>
          <TouchableOpacity onPress={onCall} style={styles.callButton}>
            <Phone size={16} color={colors.onPrimary} />
          </TouchableOpacity>
        </View>

        <View style={styles.footer}>
          <View style={styles.hoursRow}>
            <Clock size={14} color={colors.onSurfaceVariant} />
            <Text style={styles.serviceHours}>Service Hours: {bank.serviceHours}</Text>
          </View>
          <TouchableOpacity onPress={onShare} style={styles.shareButton}>
            <Share size={16} color={colors.onSurfaceVariant} />
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    marginHorizontal: spacing.md,
    marginVertical: spacing.sm,
  },
  content: {
    backgroundColor: colors.card,
    borderRadius: borderRadius.lg,
    padding: spacing.md,
    ...shadows.md,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginBottom: spacing.md,
  },
  logoContainer: {
    width: 48,
    height: 48,
    borderRadius: borderRadius.md,
    backgroundColor: colors.surfaceVariant,
    marginRight: spacing.sm,
  },
  logo: {
    width: '100%',
    height: '100%',
    borderRadius: borderRadius.md,
  },
  logoPlaceholder: {
    width: '100%',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: borderRadius.md,
  },
  bankInfo: {
    flex: 1,
  },
  nameRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.xs,
  },
  bankName: {
    ...typography.titleMedium,
    color: colors.onSurface,
    fontWeight: '600',
    flex: 1,
    marginRight: spacing.sm,
  },
  emergencyBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.error,
    paddingHorizontal: spacing.sm,
    paddingVertical: 2,
    borderRadius: borderRadius.lg,
  },
  emergencyText: {
    ...typography.labelSmall,
    color: colors.onPrimary,
    fontWeight: '600',
    marginLeft: 2,
  },
  bankType: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
  },
  favoriteButton: {
    padding: spacing.sm,
  },
  contactRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  helplineNumber: {
    ...typography.titleSmall,
    color: colors.primary,
    fontWeight: '600',
    flex: 1,
    marginLeft: spacing.sm,
  },
  callButton: {
    backgroundColor: colors.primary,
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  hoursRow: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  serviceHours: {
    ...typography.bodySmall,
    color: colors.onSurfaceVariant,
    marginLeft: spacing.sm,
  },
  shareButton: {
    padding: spacing.sm,
  },
});