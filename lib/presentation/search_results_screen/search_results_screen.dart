import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/no_results_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_filter_chips.dart';
import './widgets/search_result_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _allBanks = [];
  List<Map<String, dynamic>> _filteredBanks = [];
  List<String> _selectedFilters = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  bool _showRecentSearches = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _searchFocusNode.addListener(_onFocusChange);

    // Get search query from navigation arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['query'] != null) {
        _currentQuery = args['query'] as String;
        _searchController.text = _currentQuery;
        _performSearch(_currentQuery);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _allBanks = [
      {
        "id": 1,
        "name": "Chase Bank",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&h=200&fit=crop",
        "helplineNumber": "1-800-935-9935",
        "services": ["Credit Cards", "Loans", "Savings", "Investment"],
        "availability": "24/7",
        "isEmergency": true,
        "email": "support@chase.com",
        "chatUrl": "https://chase.com/chat",
        "relevanceScore": 95,
        "lastUpdated": "2025-08-09",
        "isFavorite": false,
      },
      {
        "id": 2,
        "name": "Bank of America",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop",
        "helplineNumber": "1-800-432-1000",
        "services": ["Credit Cards", "Mortgages", "Business Banking"],
        "availability": "24/7",
        "isEmergency": true,
        "email": "help@bankofamerica.com",
        "chatUrl": "https://bankofamerica.com/chat",
        "relevanceScore": 92,
        "lastUpdated": "2025-08-09",
        "isFavorite": true,
      },
      {
        "id": 3,
        "name": "Wells Fargo",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop",
        "helplineNumber": "1-800-869-3557",
        "services": ["Personal Banking", "Loans", "Investment"],
        "availability": "Mon-Fri 8AM-8PM",
        "isEmergency": false,
        "email": "customerservice@wellsfargo.com",
        "chatUrl": "https://wellsfargo.com/chat",
        "relevanceScore": 88,
        "lastUpdated": "2025-08-08",
        "isFavorite": false,
      },
      {
        "id": 4,
        "name": "Citibank",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1559526324-593bc073d938?w=200&h=200&fit=crop",
        "helplineNumber": "1-800-374-9700",
        "services": [
          "Credit Cards",
          "International Banking",
          "Wealth Management"
        ],
        "availability": "24/7",
        "isEmergency": true,
        "email": "support@citi.com",
        "chatUrl": "https://citi.com/chat",
        "relevanceScore": 90,
        "lastUpdated": "2025-08-09",
        "isFavorite": false,
      },
      {
        "id": 5,
        "name": "US Bank",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=200&h=200&fit=crop",
        "helplineNumber": "1-800-872-2657",
        "services": ["Personal Banking", "Business Banking", "Mortgages"],
        "availability": "24/7",
        "isEmergency": false,
        "email": "help@usbank.com",
        "chatUrl": "https://usbank.com/chat",
        "relevanceScore": 85,
        "lastUpdated": "2025-08-09",
        "isFavorite": false,
      },
      {
        "id": 6,
        "name": "PNC Bank",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=200&h=200&fit=crop",
        "helplineNumber": "1-888-762-2265",
        "services": ["Personal Banking", "Student Loans", "Auto Loans"],
        "availability": "Mon-Fri 7AM-10PM",
        "isEmergency": false,
        "email": "customercare@pnc.com",
        "chatUrl": "https://pnc.com/chat",
        "relevanceScore": 82,
        "lastUpdated": "2025-08-08",
        "isFavorite": true,
      },
      {
        "id": 7,
        "name": "Capital One",
        "type": "Private",
        "logo":
            "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=200&h=200&fit=crop",
        "helplineNumber": "1-877-383-4802",
        "services": ["Credit Cards", "Auto Loans", "Savings"],
        "availability": "24/7",
        "isEmergency": true,
        "email": "support@capitalone.com",
        "chatUrl": "https://capitalone.com/chat",
        "relevanceScore": 87,
        "lastUpdated": "2025-08-09",
        "isFavorite": false,
      },
      {
        "id": 8,
        "name": "TD Bank",
        "type": "Foreign",
        "logo":
            "https://images.unsplash.com/photo-1560472355-536de3962603?w=200&h=200&fit=crop",
        "helplineNumber": "1-888-751-9000",
        "services": ["Personal Banking", "Business Banking", "Investment"],
        "availability": "24/7",
        "isEmergency": false,
        "email": "help@td.com",
        "chatUrl": "https://td.com/chat",
        "relevanceScore": 83,
        "lastUpdated": "2025-08-09",
        "isFavorite": false,
      },
    ];

    _recentSearches = [
      "Chase Bank",
      "Credit Card Support",
      "Emergency Banking",
      "Wells Fargo",
      "Loan Services",
    ];

    _filteredBanks = List.from(_allBanks);
  }

  void _onFocusChange() {
    setState(() {
      _showRecentSearches =
          _searchFocusNode.hasFocus && _searchController.text.isEmpty;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
      _currentQuery = query;
      _showRecentSearches = false;
    });

    // Add to recent searches if not empty and not already present
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    }

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _filterBanks();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _filterBanks() {
    List<Map<String, dynamic>> filtered = List.from(_allBanks);

    // Apply text search
    if (_currentQuery.isNotEmpty) {
      filtered = filtered.where((bank) {
        final bankName = (bank['name'] as String).toLowerCase();
        final services = (bank['services'] as List).join(' ').toLowerCase();
        final type = (bank['type'] as String).toLowerCase();
        final query = _currentQuery.toLowerCase();

        return bankName.contains(query) ||
            services.contains(query) ||
            type.contains(query);
      }).toList();

      // Calculate relevance scores
      for (var bank in filtered) {
        int score = 0;
        final bankName = (bank['name'] as String).toLowerCase();
        final services = (bank['services'] as List).join(' ').toLowerCase();
        final query = _currentQuery.toLowerCase();

        if (bankName.startsWith(query))
          score += 50;
        else if (bankName.contains(query)) score += 30;

        if (services.contains(query)) score += 20;

        if (bank['isEmergency'] == true) score += 10;
        if (bank['availability'] == '24/7') score += 5;

        bank['relevanceScore'] = score;
      }

      // Sort by relevance
      filtered.sort((a, b) =>
          (b['relevanceScore'] as int).compareTo(a['relevanceScore'] as int));
    }

    // Apply filters
    if (_selectedFilters.isNotEmpty) {
      filtered = filtered.where((bank) {
        return _selectedFilters.every((filter) {
          switch (filter) {
            case 'public':
              return (bank['type'] as String).toLowerCase() == 'public';
            case 'private':
              return (bank['type'] as String).toLowerCase() == 'private';
            case 'credit_card':
              return (bank['services'] as List).any((service) =>
                  (service as String).toLowerCase().contains('credit'));
            case 'loans':
              return (bank['services'] as List).any((service) =>
                  (service as String).toLowerCase().contains('loan'));
            case 'available':
              return bank['availability'] == '24/7';
            case 'emergency':
              return bank['isEmergency'] == true;
            default:
              return true;
          }
        });
      }).toList();
    }

    setState(() {
      _filteredBanks = filtered;
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
    _filterBanks();
  }

  void _clearFilters() {
    setState(() {
      _selectedFilters.clear();
    });
    _filterBanks();
  }

  void _clearSearchHistory() {
    setState(() {
      _recentSearches.clear();
      _showRecentSearches = false;
    });
    Fluttertoast.showToast(
      msg: "Search history cleared",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
    _searchFocusNode.unfocus();
  }

  void _callBank(Map<String, dynamic> bank) {
    Fluttertoast.showToast(
      msg: "Calling ${bank['name']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleFavorite(Map<String, dynamic> bank) {
    setState(() {
      bank['isFavorite'] = !(bank['isFavorite'] as bool);
    });

    Fluttertoast.showToast(
      msg: bank['isFavorite']
          ? "${bank['name']} added to favorites"
          : "${bank['name']} removed from favorites",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareBank(Map<String, dynamic> bank) {
    Fluttertoast.showToast(
      msg: "Sharing ${bank['name']} contact details...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _navigateToBankDetail(Map<String, dynamic> bank) {
    Navigator.pushNamed(
      context,
      '/bank-detail-screen',
      arguments: {
        'bank': bank,
        'searchQuery': _currentQuery,
      },
    );
  }

  void _navigateToBankList() {
    Navigator.pushReplacementNamed(context, '/bank-list-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          _currentQuery.isEmpty
              ? 'Search Banks'
              : 'Results for "$_currentQuery"',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (_currentQuery.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _currentQuery = '';
                  _filteredBanks = List.from(_allBanks);
                  _selectedFilters.clear();
                });
              },
              icon: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search banks, services, or help...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _showRecentSearches = true;
                                });
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showRecentSearches =
                            value.isEmpty && _searchFocusNode.hasFocus;
                      });
                    },
                    onSubmitted: _performSearch,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => _performSearch(_searchController.text),
                    icon: CustomIconWidget(
                      iconName: 'search',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          if (!_showRecentSearches &&
              (_currentQuery.isNotEmpty || _selectedFilters.isNotEmpty))
            SearchFilterChips(
              selectedFilters: _selectedFilters,
              onFilterToggle: _toggleFilter,
              onClearFilters: _clearFilters,
            ),

          // Content
          Expanded(
            child: _showRecentSearches
                ? SingleChildScrollView(
                    child: RecentSearchesWidget(
                      recentSearches: _recentSearches,
                      onSearchTap: _onSearchTap,
                      onClearHistory: _clearSearchHistory,
                    ),
                  )
                : _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      )
                    : _filteredBanks.isEmpty
                        ? NoResultsWidget(
                            searchQuery: _currentQuery,
                            onBrowseAll: _navigateToBankList,
                            onSuggestionTap: _onSearchTap,
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              _filterBanks();
                            },
                            color: AppTheme.lightTheme.colorScheme.primary,
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 2.h),
                              itemCount: _filteredBanks.length,
                              itemBuilder: (context, index) {
                                final bank = _filteredBanks[index];
                                return SearchResultCard(
                                  bank: bank,
                                  searchQuery: _currentQuery,
                                  onTap: () => _navigateToBankDetail(bank),
                                  onCall: () => _callBank(bank),
                                  onFavorite: () => _toggleFavorite(bank),
                                  onShare: () => _shareBank(bank),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
