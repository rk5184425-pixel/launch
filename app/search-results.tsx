import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TextInput,
  TouchableOpacity,
  RefreshControl,
} from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import {
  ArrowLeft,
  Search,
  X,
  Mic,
  Filter,
  Phone,
  Heart,
  Share2,
  Clock,
  History,
} from 'lucide-react-native';
import { colors, typography, spacing, borderRadius, shadows } from '../src/constants/theme';
import { mockBanks } from '../src/data/mockBanks';
import { Bank } from '../src/types/bank';
import BankCard from '../src/components/BankCard';
import Toast from 'react-native-toast-message';

interface FilterChipProps {
  label: string;
  isSelected: boolean;
  onPress: () => void;
}

function FilterChip({ label, isSelected, onPress }: FilterChipProps) {
  return (
    <TouchableOpacity
      style={[styles.filterChip, isSelected && styles.filterChipSelected]}
      onPress={onPress}
    >
      <Text style={[styles.filterChipText, isSelected && styles.filterChipTextSelected]}>
        {label}
      </Text>
    </TouchableOpacity>
  );
}

export default function SearchResultsScreen() {
  const params = useLocalSearchParams();
  const [searchQuery, setSearchQuery] = useState((params.query as string) || '');
  const [filteredBanks, setFilteredBanks] = useState<Bank[]>([]);
  const [selectedFilters, setSelectedFilters] = useState<string[]>([]);
  const [favoriteIds, setFavoriteIds] = useState<string[]>([]);
  const [recentSearches, setRecentSearches] = useState<string[]>([
    'Chase Bank',
    'Credit Card Support',
    'Emergency Banking',
    'Wells Fargo',
    'Loan Services',
  ]);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [showRecentSearches, setShowRecentSearches] = useState(false);

  const filters = [
    'Public Banks',
    'Private Banks',
    'Credit Cards',
    'Loans',
    '24/7 Available',
    'Emergency',
  ];

  useEffect(() => {
    filterBanks();
  }, [searchQuery, selectedFilters]);

  useEffect(() => {
    setShowRecentSearches(searchQuery.length === 0);
  }, [searchQuery]);

  const filterBanks = () => {
    let filtered = [...mockBanks];

    // Apply search filter
    if (searchQuery) {
      filtered = filtered.filter(bank =>
        bank.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        bank.type.toLowerCase().includes(searchQuery.toLowerCase()) ||
        bank.services.some(service => 
          service.toLowerCase().includes(searchQuery.toLowerCase())
        ) ||
        bank.helpline.includes(searchQuery)
      );
    }

    // Apply category filters
    if (selectedFilters.length > 0) {
      filtered = filtered.filter(bank => {
        return selectedFilters.every(filter => {
          switch (filter) {
            case 'Public Banks':
              return bank.type === 'Public';
            case 'Private Banks':
              return bank.type === 'Private';
            case 'Credit Cards':
              return bank.services.some(service => 
                service.toLowerCase().includes('credit')
              );
            case 'Loans':
              return bank.services.some(service => 
                service.toLowerCase().includes('loan')
              );
            case '24/7 Available':
              return bank.serviceHours === '24/7';
            case 'Emergency':
              return bank.isEmergency;
            default:
              return true;
          }
        });
      });
    }

    setFilteredBanks(filtered);
  };

  const handleSearch = (text: string) => {
    setSearchQuery(text);
    if (text && !recentSearches.includes(text)) {
      setRecentSearches(prev => [text, ...prev.slice(0, 4)]);
    }
  };

  const clearSearch = () => {
    setSearchQuery('');
    setShowRecentSearches(true);
  };

  const toggleFilter = (filter: string) => {
    setSelectedFilters(prev => 
      prev.includes(filter) 
        ? prev.filter(f => f !== filter)
        : [...prev, filter]
    );
  };

  const clearFilters = () => {
    setSelectedFilters([]);
  };

  const toggleFavorite = (bankId: string) => {
    setFavoriteIds(prev => {
      const newFavorites = prev.includes(bankId)
        ? prev.filter(id => id !== bankId)
        : [...prev, bankId];
      
      const bank = mockBanks.find(b => b.id === bankId);
      Toast.show({
        type: 'success',
        text1: newFavorites.includes(bankId) 
          ? `${bank?.name} added to favorites`
          : `${bank?.name} removed from favorites`,
      });
      
      return newFavorites;
    });
  };

  const handleBankPress = (bank: Bank) => {
    router.push({
      pathname: '/bank-detail',
      params: { bankId: bank.id }
    });
  };

  const handleCall = (bank: Bank) => {
    Toast.show({
      type: 'success',
      text1: `Calling ${bank.name}...`,
    });
  };

  const handleShare = (bank: Bank) => {
    Toast.show({
      type: 'success',
      text1: `Sharing ${bank.name} contact details...`,
    });
  };

  const onRefresh = async () => {
    setIsRefreshing(true);
    await new Promise(resolve => setTimeout(resolve, 1000));
    setIsRefreshing(false);
  };

  const renderRecentSearches = () => (
    <View style={styles.recentSearchesContainer}>
      <View style={styles.recentSearchesHeader}>
        <View style={styles.recentSearchesTitle}>
          <History size={20} color={colors.primary} />
          <Text style={styles.recentSearchesText}>Recent Searches</Text>
        </View>
        <TouchableOpacity onPress={() => setRecentSearches([])}>
          <Text style={styles.clearText}>Clear</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.recentSearchesList}>
        {recentSearches.map((search, index) => (
          <TouchableOpacity
            key={index}
            style={styles.recentSearchItem}
            onPress={() => {
              setSearchQuery(search);
              setShowRecentSearches(false);
            }}
          >
            <Search size={16} color={colors.onSurfaceVariant} />
            <Text style={styles.recentSearchItemText}>{search}</Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Search size={64} color={colors.onSurfaceVariant} />
      <Text style={styles.emptyStateTitle}>No results found</Text>
      <Text style={styles.emptyStateSubtitle}>
        Try adjusting your search or filters
      </Text>
      <TouchableOpacity style={styles.browseAllButton} onPress={() => router.push('/bank-list')}>
        <Text style={styles.browseAllButtonText}>Browse All Banks</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
          <ArrowLeft size={24} color={colors.onSurface} />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>
          {searchQuery ? `Results for "${searchQuery}"` : 'Search Banks'}
        </Text>
        {searchQuery.length > 0 && (
          <TouchableOpacity onPress={clearSearch} style={styles.clearButton}>
            <X size={24} color={colors.onSurface} />
          </TouchableOpacity>
        )}
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <View style={styles.searchBar}>
          <Search size={20} color={colors.onSurfaceVariant} />
          <TextInput
            style={styles.searchInput}
            placeholder="Search banks, services, or help..."
            value={searchQuery}
            onChangeText={handleSearch}
            placeholderTextColor={colors.onSurfaceVariant}
          />
          {searchQuery.length > 0 && (
            <TouchableOpacity onPress={clearSearch}>
              <X size={20} color={colors.onSurfaceVariant} />
            </TouchableOpacity>
          )}
        </View>
        <TouchableOpacity style={styles.micButton}>
          <Mic size={20} color={colors.onPrimary} />
        </TouchableOpacity>
      </View>

      {/* Filter Chips */}
      {!showRecentSearches && (
        <View style={styles.filtersContainer}>
          <FlatList
            horizontal
            data={filters}
            renderItem={({ item }) => (
              <FilterChip
                label={item}
                isSelected={selectedFilters.includes(item)}
                onPress={() => toggleFilter(item)}
              />
            )}
            keyExtractor={(item) => item}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.filtersList}
          />
          {selectedFilters.length > 0 && (
            <TouchableOpacity style={styles.clearFiltersButton} onPress={clearFilters}>
              <Text style={styles.clearFiltersText}>Clear Filters ({selectedFilters.length})</Text>
            </TouchableOpacity>
          )}
        </View>
      )}

      {/* Content */}
      {showRecentSearches ? (
        <ScrollView style={styles.content}>
          {renderRecentSearches()}
        </ScrollView>
      ) : filteredBanks.length === 0 ? (
        renderEmptyState()
      ) : (
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
          contentContainerStyle={styles.listContainer}
        />
      )}
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
    flex: 1,
    textAlign: 'center',
  },
  clearButton: {
    padding: spacing.sm,
  },
  searchContainer: {
    flexDirection: 'row',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    backgroundColor: colors.surface,
    ...shadows.sm,
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
  micButton: {
    backgroundColor: colors.primary,
    padding: spacing.sm,
    borderRadius: borderRadius.lg,
  },
  filtersContainer: {
    backgroundColor: colors.surface,
    paddingVertical: spacing.sm,
  },
  filtersList: {
    paddingHorizontal: spacing.md,
  },
  filterChip: {
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
  clearFiltersButton: {
    alignSelf: 'center',
    marginTop: spacing.sm,
  },
  clearFiltersText: {
    ...typography.labelMedium,
    color: colors.error,
    fontWeight: '500',
  },
  content: {
    flex: 1,
  },
  recentSearchesContainer: {
    margin: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: borderRadius.lg,
    padding: spacing.md,
    ...shadows.sm,
  },
  recentSearchesHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  recentSearchesTitle: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  recentSearchesText: {
    ...typography.titleSmall,
    color: colors.onSurface,
    fontWeight: '600',
    marginLeft: spacing.sm,
  },
  clearText: {
    ...typography.labelMedium,
    color: colors.error,
    fontWeight: '500',
  },
  recentSearchesList: {
    gap: spacing.sm,
  },
  recentSearchItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.sm,
  },
  recentSearchItemText: {
    ...typography.bodyMedium,
    color: colors.onSurface,
    marginLeft: spacing.sm,
  },
  listContainer: {
    paddingBottom: spacing.xl,
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
    marginTop: spacing.lg,
    marginBottom: spacing.sm,
  },
  emptyStateSubtitle: {
    ...typography.bodyMedium,
    color: colors.onSurfaceVariant,
    textAlign: 'center',
    marginBottom: spacing.xl,
  },
  browseAllButton: {
    backgroundColor: colors.primary,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    borderRadius: borderRadius.lg,
  },
  browseAllButtonText: {
    ...typography.labelLarge,
    color: colors.onPrimary,
    fontWeight: '600',
  },
});