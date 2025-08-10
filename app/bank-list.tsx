import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  TextInput,
  RefreshControl,
  Alert,
} from 'react-native';
import { router } from 'expo-router';
import {
  Search,
  Settings,
  Mic,
  Heart,
  Clock,
  History,
} from 'lucide-react-native';
import { colors, typography, spacing, borderRadius, shadows } from '../src/constants/theme';
import { mockBanks } from '../src/data/mockBanks';
import { Bank } from '../src/types/bank';
import BankCard from '../src/components/BankCard';
import Toast from 'react-native-toast-message';

export default function BankListScreen() {
  const [banks, setBanks] = useState<Bank[]>(mockBanks);
  const [filteredBanks, setFilteredBanks] = useState<Bank[]>(mockBanks);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFilter, setSelectedFilter] = useState('All');
  const [favoriteIds, setFavoriteIds] = useState<string[]>([]);
  const [recentCallIds, setRecentCallIds] = useState<string[]>([]);
  const [activeTab, setActiveTab] = useState<'banks' | 'favorites' | 'recent'>('banks');
  const [isRefreshing, setIsRefreshing] = useState(false);

  const filters = ['All', 'Public', 'Private', 'Cooperative', 'Foreign'];

  useEffect(() => {
    filterBanks();
  }, [searchQuery, selectedFilter, activeTab]);

  const filterBanks = () => {
    let filtered = [...banks];

    // Apply search filter
    if (searchQuery) {
      filtered = filtered.filter(bank =>
        bank.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        bank.type.toLowerCase().includes(searchQuery.toLowerCase()) ||
        bank.helpline.includes(searchQuery)
      );
    }

    // Apply category filter
    if (selectedFilter !== 'All') {
      filtered = filtered.filter(bank => bank.type === selectedFilter);
    }

    // Apply tab filter
    if (activeTab === 'favorites') {
      filtered = filtered.filter(bank => favoriteIds.includes(bank.id));
    } else if (activeTab === 'recent') {
      filtered = recentCallIds
        .map(id => banks.find(bank => bank.id === id))
        .filter(Boolean) as Bank[];
    }

    setFilteredBanks(filtered);
  };

  const handleSearch = (text: string) => {
    setSearchQuery(text);
  };

  const clearSearch = () => {
    setSearchQuery('');
  };

  const toggleFavorite = (bankId: string) => {
    setFavoriteIds(prev => {
      const newFavorites = prev.includes(bankId)
        ? prev.filter(id => id !== bankId)
        : [...prev, bankId];
      
      const bank = banks.find(b => b.id === bankId);
      Toast.show({
        type: 'success',
        text1: newFavorites.includes(bankId) 
          ? `${bank?.name} added to favorites`
          : `${bank?.name} removed from favorites`,
      });
      
      return newFavorites;
    });
  };

  const addToRecent = (bankId: string) => {
    setRecentCallIds(prev => {
      const newRecent = [bankId, ...prev.filter(id => id !== bankId)];
      return newRecent.slice(0, 10); // Keep only last 10
    });
  };

  const handleBankPress = (bank: Bank) => {
    addToRecent(bank.id);
    router.push({
      pathname: '/bank-detail',
      params: { bankId: bank.id }
    });
  };

  const handleCall = (bank: Bank) => {
    addToRecent(bank.id);
    Alert.alert(
      'Call Bank',
      `Do you want to call ${bank.name}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { 
          text: 'Call', 
          onPress: () => {
            Toast.show({
              type: 'success',
              text1: `Calling ${bank.name}...`,
            });
          }
        }
      ]
    );
  };

  const handleShare = (bank: Bank) => {
    Toast.show({
      type: 'success',
      text1: `Sharing ${bank.name} contact details...`,
    });
  };

  const onRefresh = async () => {
    setIsRefreshing(true);
    // Simulate refresh
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsRefreshing(false);
  };

  const getBankCountByType = (type: string) => {
    if (type === 'All') return banks.length;
    return banks.filter(bank => bank.type === type).length;
  };

  const renderFilterChip = (filter: string) => {
    const isSelected = selectedFilter === filter;
    const count = getBankCountByType(filter);

    return (
      <TouchableOpacity
        key={filter}
        style={[styles.filterChip, isSelected && styles.filterChipSelected]}
        onPress={() => setSelectedFilter(filter)}
      >
        <Text style={[styles.filterChipText, isSelected && styles.filterChipTextSelected]}>
          {filter}
        </Text>
        {count > 0 && (
          <View style={[styles.filterChipBadge, isSelected && styles.filterChipBadgeSelected]}>
            <Text style={[styles.filterChipBadgeText, isSelected && styles.filterChipBadgeTextSelected]}>
              {count}
            </Text>
          </View>
        )}
      </TouchableOpacity>
    );
  };

  const renderTabButton = (tab: 'banks' | 'favorites' | 'recent', label: string, icon: React.ReactNode) => {
    const isActive = activeTab === tab;
    return (
      <TouchableOpacity
        style={[styles.tabButton, isActive && styles.tabButtonActive]}
        onPress={() => setActiveTab(tab)}
      >
        {icon}
        <Text style={[styles.tabButtonText, isActive && styles.tabButtonTextActive]}>
          {label}
        </Text>
      </TouchableOpacity>
    );
  };

  const renderEmptyState = () => {
    let title = 'No Banks Found';
    let subtitle = 'Try adjusting your search or filters';
    
    if (activeTab === 'favorites') {
      title = 'No Favorites Yet';
      subtitle = 'Add banks to favorites for quick access';
    } else if (activeTab === 'recent') {
      title = 'No Recent Calls';
      subtitle = 'Your recent calls will appear here';
    }

    return (
      <View style={styles.emptyState}>
        <Text style={styles.emptyStateTitle}>{title}</Text>
        <Text style={styles.emptyStateSubtitle}>{subtitle}</Text>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Bank Helpline Hub</Text>
        <TouchableOpacity onPress={() => router.push('/settings')}>
          <Settings size={24} color={colors.onSurface} />
        </TouchableOpacity>
      </View>

      {/* Tabs */}
      <View style={styles.tabContainer}>
        {renderTabButton('banks', 'Banks', <Search size={16} color={activeTab === 'banks' ? colors.onPrimary : colors.primary} />)}
        {renderTabButton('favorites', 'Favorites', <Heart size={16} color={activeTab === 'favorites' ? colors.onPrimary : colors.primary} />)}
        {renderTabButton('recent', 'Recent', <History size={16} color={activeTab === 'recent' ? colors.onPrimary : colors.primary} />)}
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Search size={20} color={colors.onSurfaceVariant} />
          <TextInput
            style={styles.searchInput}
            placeholder="Search banks..."
            value={searchQuery}
            onChangeText={handleSearch}
            placeholderTextColor={colors.onSurfaceVariant}
          />
          {searchQuery.length > 0 && (
            <TouchableOpacity onPress={clearSearch}>
              <Text style={styles.clearButton}>✕</Text>
            </TouchableOpacity>
          )}
        </View>
        <TouchableOpacity 
          style={styles.filterButton}
          onPress={() => router.push('/search-results')}
        >
          <Search size={20} color={colors.onPrimary} />
        </TouchableOpacity>
      </View>

      {/* Filter Chips - only show on banks tab */}
      {activeTab === 'banks' && (
        <View style={styles.filterContainer}>
          <FlatList
            horizontal
            data={filters}
            renderItem={({ item }) => renderFilterChip(item)}
            keyExtractor={(item) => item}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.filterList}
          />
        </View>
      )}

      {/* Bank List */}
      <FlatList
        data={filteredBanks}
        renderItem={({ item }) => (
          <BankCard
            bank={item}
            isFavorite={favoriteIds.includes(item.id)}
            onPress={() => handleBankPress(item)}
            onCall={() => handleCall(item)}
            onFavoriteToggle={() => toggleFavorite(item.id)}
            onShare={() => handleShare(item)}
          />
        )}
        keyExtractor={(item) => item.id}
        refreshControl={
          <RefreshControl refreshing={isRefreshing} onRefresh={onRefresh} />
        }
        ListEmptyComponent={renderEmptyState}
        contentContainerStyle={styles.listContainer}
      />

      {/* Floating Action Button */}
      <TouchableOpacity 
        style={styles.fab}
        onPress={() => {
          Toast.show({
            type: 'info',
            text1: 'Voice search activated',
          });
        }}
      >
        <Mic size={24} color={colors.onPrimary} />
      </TouchableOpacity>
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
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingTop: spacing.xl,
    paddingBottom: spacing.md,
    backgroundColor: colors.surface,
  },
  headerTitle: {
    ...typography.titleLarge,
    color: colors.onSurface,
    fontWeight: '600',
  },
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: colors.surfaceVariant,
    marginHorizontal: spacing.md,
    borderRadius: borderRadius.lg,
    padding: 4,
  },
  tabButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.lg,
  },
  tabButtonActive: {
    backgroundColor: colors.primary,
  },
  tabButtonText: {
    ...typography.labelMedium,
    color: colors.primary,
    marginLeft: spacing.xs,
    fontWeight: '500',
  },
  tabButtonTextActive: {
    color: colors.onPrimary,
  },
  searchContainer: {
    flexDirection: 'row',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    alignItems: 'center',
  },
  searchBar: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surfaceVariant,
    borderRadius: borderRadius.lg,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    marginRight: spacing.sm,
  },
  searchInput: {
    flex: 1,
    ...typography.bodyMedium,
    color: colors.onSurface,
    marginLeft: spacing.sm,
  },
  clearButton: {
    ...typography.titleMedium,
    color: colors.onSurfaceVariant,
    padding: spacing.xs,
  },
  filterButton: {
    backgroundColor: colors.primary,
    padding: spacing.sm,
    borderRadius: borderRadius.lg,
  },
  filterContainer: {
    paddingVertical: spacing.sm,
  },
  filterList: {
    paddingHorizontal: spacing.md,
  },
  filterChip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surfaceVariant,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.xl,
    marginRight: spacing.sm,
    borderWidth: 1,
    borderColor: colors.outline,
  },
  filterChipSelected: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  filterChipText: {
    ...typography.labelMedium,
    color: colors.primary,
    fontWeight: '500',
  },
  filterChipTextSelected: {
    color: colors.onPrimary,
  },
  filterChipBadge: {
    backgroundColor: colors.primary,
    paddingHorizontal: spacing.xs,
    paddingVertical: 2,
    borderRadius: borderRadius.sm,
    marginLeft: spacing.xs,
  },
  filterChipBadgeSelected: {
    backgroundColor: colors.onPrimary,
  },
  filterChipBadgeText: {
    ...typography.labelSmall,
    color: colors.onPrimary,
    fontWeight: '600',
  },
  filterChipBadgeTextSelected: {
    color: colors.primary,
  },
  listContainer: {
    paddingBottom: 100,
  },
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.xl,
  },
  emptyStateTitle: {
    ...typography.headlineSmall,
    color: colors.onSurface,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: spacing.sm,
  },
  emptyStateSubtitle: {
    ...typography.bodyMedium,
    color: colors.onSurfaceVariant,
    textAlign: 'center',
  },
  fab: {
    position: 'absolute',
    bottom: spacing.xl,
    right: spacing.md,
    backgroundColor: colors.primary,
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
    ...shadows.lg,
  },
});