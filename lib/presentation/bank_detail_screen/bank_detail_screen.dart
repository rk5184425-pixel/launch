import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/bank_hero_section_widget.dart';
import './widgets/chat_support_widget.dart';
import './widgets/contact_card_widget.dart';
import './widgets/email_contact_widget.dart';

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock bank data
  final Map<String, dynamic> bankData = {
    "bankName": "Chase Bank",
    "bankLogo":
        "https://logos-world.net/wp-content/uploads/2021/02/Chase-Bank-Logo.png",
    "primaryHelpline": "1-800-935-9935",
    "emergencyHelpline": "1-800-242-7338",
    "phoneNumbers": [
      {
        "type": "General Customer Service",
        "number": "1-800-935-9935",
        "hours": "24/7 Available",
        "icon": "support_agent"
      },
      {
        "type": "Credit Card Support",
        "number": "1-800-432-3117",
        "hours": "Mon-Fri 8AM-10PM EST",
        "icon": "credit_card"
      },
      {
        "type": "Mortgage Services",
        "number": "1-800-848-9136",
        "hours": "Mon-Fri 7AM-10PM EST",
        "icon": "home"
      },
      {
        "type": "Business Banking",
        "number": "1-800-225-5935",
        "hours": "Mon-Fri 7AM-9PM EST",
        "icon": "business"
      },
      {
        "type": "Investment Services",
        "number": "1-800-392-5749",
        "hours": "Mon-Fri 8AM-8PM EST",
        "icon": "trending_up"
      }
    ],
    "emailSupport": [
      {
        "type": "General Inquiries",
        "email": "customer.service@chase.com",
        "description": "For general banking questions and account inquiries"
      },
      {
        "type": "Credit Card Issues",
        "email": "creditcard.support@chase.com",
        "description": "For credit card related concerns and disputes"
      },
      {
        "type": "Business Support",
        "email": "business.support@chase.com",
        "description": "For business banking and commercial services"
      }
    ],
    "chatSupport": [
      {
        "type": "Live Chat Support",
        "url": "https://www.chase.com/digital/customer-service",
        "availability": "Available 24/7",
        "isActive": true
      },
      {
        "type": "WhatsApp Business",
        "url": "https://wa.me/18009359935",
        "availability": "Mon-Fri 9AM-6PM EST",
        "isActive": false
      },
      {
        "type": "Facebook Messenger",
        "url": "https://m.me/chase",
        "availability": "Mon-Fri 8AM-8PM EST",
        "isActive": true
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openMaps() async {
    const String mapsUrl =
        "https://www.google.com/maps/search/Chase+Bank+near+me";
    final Uri mapsUri = Uri.parse(mapsUrl);
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _shareContact() {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact details shared successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          bankData["bankName"] as String,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _shareContact,
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      ),
      body: Column(
        children: [
          // Hero Section
          BankHeroSectionWidget(
            bankName: bankData["bankName"] as String,
            bankLogo: bankData["bankLogo"] as String,
            primaryHelpline: bankData["primaryHelpline"] as String,
            emergencyHelpline: bankData["emergencyHelpline"] as String,
          ),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Phone', style: TextStyle(fontSize: 10.sp)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'email',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Email', style: TextStyle(fontSize: 10.sp)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'chat',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Chat', style: TextStyle(fontSize: 10.sp)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Locate', style: TextStyle(fontSize: 10.sp)),
                    ],
                  ),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              dividerColor: Colors.transparent,
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Phone Numbers Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  itemCount: (bankData["phoneNumbers"] as List).length,
                  itemBuilder: (context, index) {
                    final contact = (bankData["phoneNumbers"] as List)[index]
                        as Map<String, dynamic>;
                    return ContactCardWidget(
                      contactType: contact["type"] as String,
                      contactNumber: contact["number"] as String,
                      serviceHours: contact["hours"] as String,
                      iconName: contact["icon"] as String,
                    );
                  },
                ),

                // Email Support Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  itemCount: (bankData["emailSupport"] as List).length,
                  itemBuilder: (context, index) {
                    final email = (bankData["emailSupport"] as List)[index]
                        as Map<String, dynamic>;
                    return EmailContactWidget(
                      emailType: email["type"] as String,
                      emailAddress: email["email"] as String,
                      description: email["description"] as String,
                    );
                  },
                ),

                // Chat Support Tab
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  itemCount: (bankData["chatSupport"] as List).length,
                  itemBuilder: (context, index) {
                    final chat = (bankData["chatSupport"] as List)[index]
                        as Map<String, dynamic>;
                    return ChatSupportWidget(
                      chatType: chat["type"] as String,
                      chatUrl: chat["url"] as String,
                      availability: chat["availability"] as String,
                      isActive: chat["isActive"] as bool,
                    );
                  },
                ),

                // Branch Locator Tab
                Container(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 64,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Find Nearby Branches',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Locate the nearest ${bankData["bankName"]} branch or ATM using Google Maps',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openMaps,
                          icon: CustomIconWidget(
                            iconName: 'map',
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text('Open in Maps'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 4.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareContact,
        child: CustomIconWidget(
          iconName: 'share',
          color: Colors.white,
          size: 24,
        ),
        tooltip: 'Share Bank Contact',
      ),
    );
  }
}
