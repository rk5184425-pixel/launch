import { Dimensions } from 'react-native';

const { width, height } = Dimensions.get('window');

export const colors = {
  // Primary colors
  primary: '#1B365D',
  primaryLight: '#2E5984',
  secondary: '#2E7D32',
  secondaryLight: '#4CAF50',
  
  // Surface colors
  surface: '#FAFAFA',
  surfaceVariant: '#F5F5F5',
  card: '#FFFFFF',
  
  // Text colors
  onSurface: '#212121',
  onSurfaceVariant: '#616161',
  onPrimary: '#FFFFFF',
  onSecondary: '#FFFFFF',
  
  // Status colors
  error: '#C62828',
  errorLight: '#EF5350',
  success: '#2E7D32',
  warning: '#FF9800',
  
  // Border and outline
  outline: '#E0E0E0',
  shadow: 'rgba(0, 0, 0, 0.08)',
  
  // Background
  background: '#FAFAFA',
};

export const typography = {
  // Display styles
  displayLarge: {
    fontSize: 57,
    fontWeight: '600' as const,
    letterSpacing: -0.25,
  },
  displayMedium: {
    fontSize: 45,
    fontWeight: '600' as const,
    letterSpacing: 0,
  },
  displaySmall: {
    fontSize: 36,
    fontWeight: '500' as const,
    letterSpacing: 0,
  },
  
  // Headline styles
  headlineLarge: {
    fontSize: 32,
    fontWeight: '600' as const,
    letterSpacing: 0,
  },
  headlineMedium: {
    fontSize: 28,
    fontWeight: '500' as const,
    letterSpacing: 0,
  },
  headlineSmall: {
    fontSize: 24,
    fontWeight: '500' as const,
    letterSpacing: 0,
  },
  
  // Title styles
  titleLarge: {
    fontSize: 22,
    fontWeight: '500' as const,
    letterSpacing: 0,
  },
  titleMedium: {
    fontSize: 16,
    fontWeight: '500' as const,
    letterSpacing: 0.15,
  },
  titleSmall: {
    fontSize: 14,
    fontWeight: '500' as const,
    letterSpacing: 0.1,
  },
  
  // Body styles
  bodyLarge: {
    fontSize: 16,
    fontWeight: '400' as const,
    letterSpacing: 0.5,
  },
  bodyMedium: {
    fontSize: 14,
    fontWeight: '400' as const,
    letterSpacing: 0.25,
  },
  bodySmall: {
    fontSize: 12,
    fontWeight: '400' as const,
    letterSpacing: 0.4,
  },
  
  // Label styles
  labelLarge: {
    fontSize: 14,
    fontWeight: '500' as const,
    letterSpacing: 0.1,
  },
  labelMedium: {
    fontSize: 12,
    fontWeight: '400' as const,
    letterSpacing: 0.5,
  },
  labelSmall: {
    fontSize: 11,
    fontWeight: '400' as const,
    letterSpacing: 0.5,
  },
};

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};

export const borderRadius = {
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  xxl: 24,
  full: 9999,
};

export const shadows = {
  sm: {
    shadowColor: colors.shadow,
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 1,
    shadowRadius: 2,
    elevation: 2,
  },
  md: {
    shadowColor: colors.shadow,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 1,
    shadowRadius: 4,
    elevation: 4,
  },
  lg: {
    shadowColor: colors.shadow,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 1,
    shadowRadius: 8,
    elevation: 8,
  },
};

// Responsive helpers
export const isTablet = width >= 768;
export const isLargeScreen = width >= 1024;

export const responsive = {
  width: (percentage: number) => (width * percentage) / 100,
  height: (percentage: number) => (height * percentage) / 100,
};