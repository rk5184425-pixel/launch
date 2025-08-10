import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bank_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/search_bar_widget.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({Key? key}) : super(key: key);

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  List<String> _favoriteIds = [];
  List<String> _recentCallIds = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock data for banks
  final List<Map<String, dynamic>> _allBanks = [
    {
      "id": "1",
      "name": "State Bank of India",
      "type": "Public",
      "helpline": "1800-11-2211",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop",
      "isEmergency": true,
      "email": "customercare@sbi.co.in",
      "website": "https://www.onlinesbi.com"
    },
    {
      "id": "2",
      "name": "HDFC Bank",
      "type": "Private",
      "helpline": "1800-202-6161",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "support@hdfcbank.com",
      "website": "https://www.hdfcbank.com"
    },
    {
      "id": "3",
      "name": "ICICI Bank",
      "type": "Private",
      "helpline": "1800-1080",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "customercare@icicibank.com",
      "website": "https://www.icicibank.com"
    },
    {
      "id": "4",
      "name": "Punjab National Bank",
      "type": "Public",
      "helpline": "1800-180-2222",
      "serviceHours": "9:00 AM - 6:00 PM",
      "logoUrl":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "pnbhelp@pnb.co.in",
      "website": "https://www.pnbindia.in"
    },
    {
      "id": "5",
      "name": "Axis Bank",
      "type": "Private",
      "helpline": "1800-419-5959",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "customercare@axisbank.com",
      "website": "https://www.axisbank.com"
    },
    {
      "id": "6",
      "name": "Bank of Baroda",
      "type": "Public",
      "helpline": "1800-258-4455",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop",
      "isEmergency": true,
      "email": "connect@bankofbaroda.com",
      "website": "https://www.bankofbaroda.in"
    },
    {
      "id": "7",
      "name": "Kotak Mahindra Bank",
      "type": "Private",
      "helpline": "1800-274-0110",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "service@kotak.com",
      "website": "https://www.kotak.com"
    },
    {
      "id": "8",
      "name": "Canara Bank",
      "type": "Public",
      "helpline": "1800-425-0018",
      "serviceHours": "9:00 AM - 8:00 PM",
      "logoUrl":
          "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "helpdesk@canarabank.com",
      "website": "https://www.canarabank.com"
    },
    {
      "id": "9",
      "name": "IndusInd Bank",
      "type": "Private",
      "helpline": "1800-1234",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "customer.care@indusind.com",
      "website": "https://www.indusind.com"
    },
    {
      "id": "10",
      "name": "SARASWAT Cooperative Bank",
      "type": "Cooperative",
      "helpline": "1800-233-4526",
      "serviceHours": "9:00 AM - 6:00 PM",
      "logoUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "info@saraswatbank.com",
      "website": "https://www.saraswatbank.com"
    },
    {
      "id": "11",
      "name": "Standard Chartered Bank",
      "type": "Foreign",
      "helpline": "1800-3000-0001",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "contact.india@sc.com",
      "website": "https://www.sc.com/in"
    },
    {
      "id": "12",
      "name": "HSBC Bank",
      "type": "Foreign",
      "helpline": "1800-200-2722",
      "serviceHours": "24/7",
      "logoUrl":
          "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?w=200&h=200&fit=crop",
      "isEmergency": false,
      "email": "customer.service@hsbc.co.in",
      "website": "https://www.hsbc.co.in"
    }
  ];

  List<Map<String, dynamic>> _filteredBanks = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredBanks = List.from(_allBanks);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _filterBanks() {
    List<Map<String, dynamic>> filtered = List.from(_allBanks);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((bank) {
        final name = (bank['name'] as String).toLowerCase();
        final type = (bank['type'] as String).toLowerCase();
        final helpline = (bank['helpline'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            type.contains(query) ||
            helpline.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((bank) => (bank['type'] as String) == _selectedFilter)
          .toList();
    }

    setState(() {
      _filteredBanks = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterBanks();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _filterBanks();
  }

  void _toggleFavorite(String bankId) {
    setState(() {
      if (_favoriteIds.contains(bankId)) {
        _favoriteIds.remove(bankId);
      } else {
        _favoriteIds.add(bankId);
      }
    });
  }

  void _addToRecent(String bankId) {
    setState(() {
      _recentCallIds.remove(bankId);
      _recentCallIds.insert(0, bankId);
      if (_recentCallIds.length > 10) {
        _recentCallIds = _recentCallIds.take(10).toList();
      }
    });
  }

  void _shareBank(Map<String, dynamic> bank) {
    // Handle sharing functionality
    final String shareText = '''
${bank['name']}
Helpline: ${bank['helpline']}
Service Hours: ${bank['serviceHours']}
Type: ${bank['type']}
''';
    // In real implementation, use share_plus package
    print('Sharing: $shareText');
  }

  List<Map<String, dynamic>> _getFavoriteBanks() {
    return _allBanks
        .where((bank) => _favoriteIds.contains(bank['id'] as String))
        .toList();
  }

  List<Map<String, dynamic>> _getRecentBanks() {
    return _recentCallIds
        .map((id) => _allBanks.firstWhere((bank) => bank['id'] == id))
        .toList();
  }

  int _getBankCountByType(String type) {
    if (type == 'All') return _allBanks.length;
    return _allBanks.where((bank) => bank['type'] == type).length;
  }

  Widget _buildBanksList(List<Map<String, dynamic>> banks) {
    if (banks.isEmpty) {
      return EmptyStateWidget(
        title: _tabController.index == 0
            ? 'No Banks Found'
            : _tabController.index == 1
                ? 'No Favorites Yet'
                : 'No Recent Calls',
        subtitle: _tabController.index == 0
            ? 'Try adjusting your search or filters'
            : _tabController.index == 1
                ? 'Add banks to favorites for quick access'
                : 'Your recent calls will appear here',
        iconName: _tabController.index == 0
            ? 'search_off'
            : _tabController.index == 1
                ? 'favorite_border'
                : 'history',
        onActionTap: _tabController.index == 0 ? _clearSearch : null,
        actionText: _tabController.index == 0 ? 'Clear Search' : null,
      );
    }

    return ListView.builder(
      itemCount: banks.length,
      padding: EdgeInsets.only(bottom: 10.h),
      itemBuilder: (context, index) {
        final bank = banks[index];
        final bankId = bank['id'] as String;

        return BankCardWidget(
          bankData: bank,
          isFavorite: _favoriteIds.contains(bankId),
          onTap: () {
            _addToRecent(bankId);
            Navigator.pushNamed(context, '/bank-detail-screen');
          },
          onFavoriteToggle: () => _toggleFavorite(bankId),
          onShare: () => _shareBank(bank),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Public', 'Private', 'Cooperative', 'Foreign'];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return FilterChipWidget(
            label: filter,
            count: _getBankCountByType(filter),
            isSelected: _selectedFilter == filter,
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              _filterBanks();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Bank Helpline Hub',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings-screen');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Banks'),
            Tab(text: 'Favorites'),
            Tab(text: 'Recent'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
            onFilterTap: () {
              Navigator.pushNamed(context, '/search-results-screen');
            },
          ),

          // Filter Chips (only show on Banks tab)
          if (_tabController.index == 0) _buildFilterChips(),

          // Tab Content
          Expanded(
            child: _isLoading
                ? const LoadingSkeletonWidget()
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Banks Tab
                        _buildBanksList(_filteredBanks),

                        // Favorites Tab
                        _buildBanksList(_getFavoriteBanks()),

                        // Recent Tab
                        _buildBanksList(_getRecentBanks()),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Voice search functionality
          _searchController.text = 'Voice search activated';
          _onSearchChanged(_searchController.text);
        },
        child: CustomIconWidget(
          iconName: 'mic',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 6.w,
        ),
      ),
    );
  }
}
