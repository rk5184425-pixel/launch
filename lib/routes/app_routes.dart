import 'package:flutter/material.dart';
import '../presentation/search_results_screen/search_results_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/bank_detail_screen/bank_detail_screen.dart';
import '../presentation/bank_list_screen/bank_list_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String searchResults = '/search-results-screen';
  static const String splash = '/splash-screen';
  static const String settings = '/settings-screen';
  static const String bankDetail = '/bank-detail-screen';
  static const String bankList = '/bank-list-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    searchResults: (context) => const SearchResultsScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const SettingsScreen(),
    bankDetail: (context) => const BankDetailScreen(),
    bankList: (context) => const BankListScreen(),
    // TODO: Add your other routes here
  };
}
