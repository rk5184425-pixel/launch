import { Bank } from '../types/bank';

export const mockBanks: Bank[] = [
  {
    id: '1',
    name: 'Chase Bank',
    type: 'Private',
    helpline: '1-800-935-9935',
    serviceHours: '24/7',
    logoUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200&h=200&fit=crop',
    isEmergency: true,
    email: 'customer.service@chase.com',
    website: 'https://www.chase.com',
    services: ['Credit Cards', 'Loans', 'Savings', 'Investment'],
    lastUpdated: '2025-08-09',
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
  },
  {
    id: '2',
    name: 'Bank of America',
    type: 'Private',
    helpline: '1-800-432-1000',
    serviceHours: '24/7',
    logoUrl: 'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=200&fit=crop',
    isEmergency: true,
    email: 'help@bankofamerica.com',
    website: 'https://www.bankofamerica.com',
    services: ['Credit Cards', 'Mortgages', 'Business Banking'],
    lastUpdated: '2025-08-09',
    phoneNumbers: [
      {
        type: 'General Customer Service',
        number: '1-800-432-1000',
        hours: '24/7 Available',
        icon: 'phone'
      },
      {
        type: 'Credit Card Support',
        number: '1-800-421-2110',
        hours: '24/7 Available',
        icon: 'credit-card'
      }
    ],
    emailSupport: [
      {
        type: 'General Support',
        email: 'help@bankofamerica.com',
        description: 'General banking support and inquiries'
      }
    ],
    chatSupport: [
      {
        type: 'Live Chat',
        url: 'https://www.bankofamerica.com/chat',
        availability: '24/7',
        isActive: true
      }
    ]
  },
  {
    id: '3',
    name: 'Wells Fargo',
    type: 'Private',
    helpline: '1-800-869-3557',
    serviceHours: '24/7',
    logoUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=200&fit=crop',
    isEmergency: false,
    email: 'customerservice@wellsfargo.com',
    website: 'https://www.wellsfargo.com',
    services: ['Personal Banking', 'Loans', 'Investment'],
    lastUpdated: '2025-08-08',
    phoneNumbers: [
      {
        type: 'Customer Service',
        number: '1-800-869-3557',
        hours: '24/7 Available',
        icon: 'phone'
      }
    ],
    emailSupport: [
      {
        type: 'Customer Service',
        email: 'customerservice@wellsfargo.com',
        description: 'General customer service inquiries'
      }
    ],
    chatSupport: [
      {
        type: 'Online Chat',
        url: 'https://wellsfargo.com/chat',
        availability: 'Mon-Fri 8AM-8PM',
        isActive: true
      }
    ]
  },
  {
    id: '4',
    name: 'Citibank',
    type: 'Private',
    helpline: '1-800-374-9700',
    serviceHours: '24/7',
    logoUrl: 'https://images.unsplash.com/photo-1559526324-593bc073d938?w=200&h=200&fit=crop',
    isEmergency: true,
    email: 'support@citi.com',
    website: 'https://www.citi.com',
    services: ['Credit Cards', 'International Banking', 'Wealth Management'],
    lastUpdated: '2025-08-09',
    phoneNumbers: [
      {
        type: 'Customer Service',
        number: '1-800-374-9700',
        hours: '24/7 Available',
        icon: 'phone'
      }
    ],
    emailSupport: [
      {
        type: 'Support',
        email: 'support@citi.com',
        description: 'General support and account assistance'
      }
    ],
    chatSupport: [
      {
        type: 'Live Chat',
        url: 'https://citi.com/chat',
        availability: '24/7',
        isActive: true
      }
    ]
  },
  {
    id: '5',
    name: 'US Bank',
    type: 'Private',
    helpline: '1-800-872-2657',
    serviceHours: '24/7',
    logoUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=200&h=200&fit=crop',
    isEmergency: false,
    email: 'help@usbank.com',
    website: 'https://www.usbank.com',
    services: ['Personal Banking', 'Business Banking', 'Mortgages'],
    lastUpdated: '2025-08-09',
    phoneNumbers: [
      {
        type: 'Customer Service',
        number: '1-800-872-2657',
        hours: '24/7 Available',
        icon: 'phone'
      }
    ],
    emailSupport: [
      {
        type: 'Help',
        email: 'help@usbank.com',
        description: 'Customer help and support'
      }
    ],
    chatSupport: [
      {
        type: 'Chat Support',
        url: 'https://usbank.com/chat',
        availability: '24/7',
        isActive: true
      }
    ]
  }
];