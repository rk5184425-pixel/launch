import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = true;
  String _loadingText = "Initializing...";
  double _progress = 0.0;

  // Mock bank data for initialization
  final List<Map<String, dynamic>> _bankData = [
    {
      "id": 1,
      "name": "Chase Bank",
      "type": "Private",
      "helpline": "+1-800-935-9935",
      "email": "customer.service@chase.com",
      "services": ["Credit Cards", "Loans", "General Inquiry"],
      "hours": "24/7",
      "isEmergency": true,
      "lastUpdated": "2025-08-09"
    },
    {
      "id": 2,
      "name": "Bank of America",
      "type": "Private",
      "helpline": "+1-800-432-1000",
      "email": "help@bankofamerica.com",
      "services": ["Credit Cards", "Mortgages", "Business Banking"],
      "hours": "24/7",
      "isEmergency": true,
      "lastUpdated": "2025-08-09"
    },
    {
      "id": 3,
      "name": "Wells Fargo",
      "type": "Private",
      "helpline": "+1-800-869-3557",
      "email": "support@wellsfargo.com",
      "services": ["Personal Banking", "Loans", "Investment"],
      "hours": "24/7",
      "isEmergency": false,
      "lastUpdated": "2025-08-09"
    },
    {
      "id": 4,
      "name": "Citibank",
      "type": "Private",
      "helpline": "+1-800-374-9700",
      "email": "customercare@citi.com",
      "services": ["Credit Cards", "International Banking"],
      "hours": "Mon-Fri 8AM-8PM",
      "isEmergency": false,
      "lastUpdated": "2025-08-09"
    },
    {
      "id": 5,
      "name": "US Bank",
      "type": "Private",
      "helpline": "+1-800-872-2657",
      "email": "help@usbank.com",
      "services": ["Personal Banking", "Business Banking", "Loans"],
      "hours": "24/7",
      "isEmergency": true,
      "lastUpdated": "2025-08-09"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate database initialization
      await _loadBankDatabase();

      // Check network connectivity
      await _checkConnectivity();

      // Verify offline functionality
      await _setupOfflineData();

      // Complete initialization
      await _finalizeSetup();
    } catch (e) {
      // Handle initialization errors gracefully
      _handleInitializationError();
    }
  }

  Future<void> _loadBankDatabase() async {
    setState(() {
      _loadingText = "Loading bank database...";
      _progress = 0.2;
    });

    // Simulate database loading with realistic delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock database operations
    for (int i = 0; i < _bankData.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _progress = 0.2 + (0.3 * (i + 1) / _bankData.length);
      });
    }
  }

  Future<void> _checkConnectivity() async {
    setState(() {
      _loadingText = "Checking connectivity...";
      _progress = 0.6;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    // Mock connectivity check
    setState(() {
      _progress = 0.7;
    });
  }

  Future<void> _setupOfflineData() async {
    setState(() {
      _loadingText = "Setting up offline access...";
      _progress = 0.8;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _progress = 0.9;
    });
  }

  Future<void> _finalizeSetup() async {
    setState(() {
      _loadingText = "Finalizing setup...";
      _progress = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isLoading = false;
    });

    // Navigate to bank list screen after a brief delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/bank-list-screen');
    }
  }

  void _handleInitializationError() {
    setState(() {
      _loadingText = "Loading cached data...";
      _progress = 1.0;
      _isLoading = false;
    });

    // Navigate with cached data after error
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/bank-list-screen');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildLoadingSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 12.w,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Bank Helpline Hub',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Quick Access to Banking Support',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading) ...[
            _buildProgressIndicator(),
            SizedBox(height: 3.h),
            Text(
              _loadingText,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              '${(_progress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 8.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Ready to Connect',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 60.w,
      height: 0.8.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.w * _progress,
            height: 0.8.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.h),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
