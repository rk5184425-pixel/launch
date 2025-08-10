export interface Bank {
  id: string;
  name: string;
  type: 'Public' | 'Private' | 'Cooperative' | 'Foreign';
  helpline: string;
  serviceHours: string;
  logoUrl?: string;
  isEmergency: boolean;
  email: string;
  website?: string;
  services: string[];
  phoneNumbers: PhoneContact[];
  emailSupport: EmailContact[];
  chatSupport: ChatContact[];
  lastUpdated: string;
  relevanceScore?: number;
}

export interface PhoneContact {
  type: string;
  number: string;
  hours: string;
  icon: string;
}

export interface EmailContact {
  type: string;
  email: string;
  description: string;
}

export interface ChatContact {
  type: string;
  url: string;
  availability: string;
  isActive: boolean;
}

export interface SearchFilters {
  type?: string;
  services?: string[];
  availability?: '24/7' | 'business_hours';
  isEmergency?: boolean;
}