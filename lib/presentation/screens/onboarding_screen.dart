import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import 'home_screen.dart';

/// Onboarding screen shown on first launch
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to\nFOCUS CLOCK',
      description:
          'A minimalist clock app with customizable displays, timer, stopwatch, and alarms',
      icon: Icons.access_time_rounded,
      color: AppColors.primaryNeon,
    ),
    OnboardingPage(
      title: 'Change Clock Styles',
      description:
          'Swipe left/right on the clock screen to switch between 5 different clock faces',
      icon: Icons.swipe_left_rounded,
      color: const Color(0xff00ffaa),
    ),
    OnboardingPage(
      title: 'Customize Colors',
      description:
          'Double-tap the clock to open color picker. Swipe up/down to cycle through 18 vibrant colors',
      icon: Icons.palette_rounded,
      color: const Color(0xffff6b6b),
    ),
    OnboardingPage(
      title: 'Adjust Timer',
      description:
          'In timer: tap hours/minutes/seconds to adjust time. Use quick buttons for +30s or -10s',
      icon: Icons.timer_rounded,
      color: AppColors.accentNeon,
    ),
    OnboardingPage(
      title: 'Set Multiple Alarms',
      description:
          'Create unlimited alarms with custom labels, repeat schedules, and snooze options',
      icon: Icons.alarm_rounded,
      color: const Color(0xffff6b6b),
    ),
    OnboardingPage(
      title: 'Ready to Start!',
      description:
          'Long-press any screen to exit fullscreen mode. Enjoy your Focus Clock experience!',
      icon: Icons.rocket_launch_rounded,
      color: AppColors.primaryNeon,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'SKIP',
                  style: GoogleFonts.comfortaa(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], isPortrait);
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _pages[index].color
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _pages[_currentPage].color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'NEXT' : 'GET STARTED',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, bool isPortrait) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: isPortrait ? 140 : 120,
            height: isPortrait ? 140 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [page.color.withOpacity(0.3), Colors.transparent],
              ),
            ),
            child: Icon(
              page.icon,
              size: isPortrait ? 80 : 70,
              color: page.color,
            ),
          ),
          SizedBox(height: isPortrait ? 48 : 32),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
              fontSize: isPortrait ? 32 : 28,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: isPortrait ? 24 : 16),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
              fontSize: isPortrait ? 16 : 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
