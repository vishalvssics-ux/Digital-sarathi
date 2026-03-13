import 'package:flutter/material.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/glass_container.dart';
import 'auth/login_screen.dart';
import '../core/utils/localization_util.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Malayalam', 'Hindi', 'Tamil'];

  List<OnboardingData> get _pages => [
    OnboardingData(
      title: LocalizationUtil.translate("onboard_welcome_title", _selectedLanguage),
      description: LocalizationUtil.translate("onboard_welcome_desc", _selectedLanguage),
      icon: Icons.auto_awesome,
    ),
    OnboardingData(
      title: LocalizationUtil.translate("onboard_learn_title", _selectedLanguage),
      description: LocalizationUtil.translate("onboard_learn_desc", _selectedLanguage),
      icon: Icons.school,
    ),
    OnboardingData(
      title: LocalizationUtil.translate("onboard_track_title", _selectedLanguage),
      description: LocalizationUtil.translate("onboard_track_desc", _selectedLanguage),
      icon: Icons.emoji_events,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    dropdownColor: const Color(0xFF1A1A5E),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    underline: const SizedBox(),
                    icon: const Icon(Icons.language, color: Colors.white),
                    items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedLanguage = v);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(30),
            child: Icon(
              data.icon,
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Indicators
          Row(
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          // Next/Get Started Button
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _pages.length - 1) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A1A5E),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _currentPage == _pages.length - 1 
                  ? LocalizationUtil.translate("onboard_get_started", _selectedLanguage)
                  : LocalizationUtil.translate("onboard_next", _selectedLanguage),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
