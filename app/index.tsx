import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Animated,
  Dimensions,
} from 'react-native';
import { router } from 'expo-router';
import { Phone } from 'lucide-react-native';
import { colors, typography } from '../src/constants/theme';

const { width, height } = Dimensions.get('window');

export default function SplashScreen() {
  const [fadeAnim] = useState(new Animated.Value(0));
  const [scaleAnim] = useState(new Animated.Value(0.8));
  const [progress, setProgress] = useState(0);
  const [loadingText, setLoadingText] = useState('Initializing...');

  useEffect(() => {
    // Start animations
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 1500,
        useNativeDriver: true,
      }),
      Animated.spring(scaleAnim, {
        toValue: 1,
        tension: 50,
        friction: 7,
        useNativeDriver: true,
      }),
    ]).start();

    // Simulate loading process
    const loadingSteps = [
      { text: 'Loading bank database...', duration: 800, progress: 0.3 },
      { text: 'Checking connectivity...', duration: 500, progress: 0.6 },
      { text: 'Setting up offline access...', duration: 400, progress: 0.8 },
      { text: 'Finalizing setup...', duration: 300, progress: 1.0 },
    ];

    let currentStep = 0;
    const executeStep = () => {
      if (currentStep < loadingSteps.length) {
        const step = loadingSteps[currentStep];
        setLoadingText(step.text);
        setProgress(step.progress);
        
        setTimeout(() => {
          currentStep++;
          executeStep();
        }, step.duration);
      } else {
        // Navigate to bank list after loading
        setTimeout(() => {
          router.replace('/bank-list');
        }, 500);
      }
    };

    executeStep();
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        <Animated.View
          style={[
            styles.logoContainer,
            {
              opacity: fadeAnim,
              transform: [{ scale: scaleAnim }],
            },
          ]}
        >
          <View style={styles.logoIcon}>
            <Phone size={60} color={colors.primary} />
          </View>
          <Text style={styles.title}>Bank Helpline Hub</Text>
          <Text style={styles.subtitle}>Quick Access to Banking Support</Text>
        </Animated.View>

        <View style={styles.loadingSection}>
          <View style={styles.progressContainer}>
            <View style={[styles.progressBar, { width: `${progress * 100}%` }]} />
          </View>
          <Text style={styles.loadingText}>{loadingText}</Text>
          <Text style={styles.progressText}>{Math.round(progress * 100)}%</Text>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.primary,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 32,
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 80,
  },
  logoIcon: {
    width: 120,
    height: 120,
    backgroundColor: 'white',
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 32,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 10 },
    shadowOpacity: 0.2,
    shadowRadius: 20,
    elevation: 10,
  },
  title: {
    ...typography.headlineMedium,
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 8,
  },
  subtitle: {
    ...typography.bodyLarge,
    color: 'rgba(255, 255, 255, 0.9)',
    textAlign: 'center',
  },
  loadingSection: {
    alignItems: 'center',
    width: '100%',
  },
  progressContainer: {
    width: '60%',
    height: 4,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    borderRadius: 2,
    marginBottom: 24,
  },
  progressBar: {
    height: '100%',
    backgroundColor: 'white',
    borderRadius: 2,
  },
  loadingText: {
    ...typography.bodyMedium,
    color: 'rgba(255, 255, 255, 0.8)',
    textAlign: 'center',
    marginBottom: 8,
  },
  progressText: {
    ...typography.labelLarge,
    color: 'rgba(255, 255, 255, 0.7)',
    fontWeight: '500',
  },
});