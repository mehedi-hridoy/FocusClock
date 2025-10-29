import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'core/constants/app_themes.dart';
import 'data/services/wakelock_service.dart';
import 'data/services/notification_service.dart';
import 'state/clock_provider.dart';
import 'state/timer_provider.dart';
import 'state/settings_provider.dart';
import 'state/alarm_provider.dart';
import 'state/reminder_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize notification service early
  await NotificationService().initialize();

  // Allow both portrait and landscape orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(AppThemes.landscapeOverlay);

  runApp(const FocusClockApp());
}

class FocusClockApp extends StatelessWidget {
  const FocusClockApp({super.key});

  // Create FirebaseAnalytics instance
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ClockProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()..initialize()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(960, 540), // Base design size for landscape
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Focus Clock',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.darkNeonTheme,
            home: const MainScreen(),
            // Add Firebase Analytics observer for screen tracking
            navigatorObservers: [observer],
          );
        },
      ),
    );
  }
}

/// Main screen with wakelock management
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final WakelockService _wakelockService = WakelockService();
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOnboardingStatus();
    _enableWakelock();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    setState(() {
      _showOnboarding = !onboardingCompleted;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disableWakelock();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enableWakelock();
    } else if (state == AppLifecycleState.paused) {
      _disableWakelock();
    }
  }

  Future<void> _enableWakelock() async {
    await _wakelockService.enable();
  }

  Future<void> _disableWakelock() async {
    await _wakelockService.disable();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return _showOnboarding ? const OnboardingScreen() : const HomeScreen();
  }
}
