import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../chat/chat_screen.dart';

import '../quiz/quiz_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';
import '../video/video_list_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/utils/localization_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatScreen(),

    const QuizScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  //  const VideoListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final language = context.watch<AuthProvider>().user?.language;
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return IconThemeData(color: Theme.of(context).colorScheme.primary);
            }
            return IconThemeData(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6));
          }),
          indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.1), 
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.chat),
              selectedIcon: const Icon(Icons.chat),
              label: LocalizationUtil.translate('nav_chat', language),
            ),
            NavigationDestination(
              icon: const Icon(Icons.book),
              selectedIcon: const Icon(Icons.book),
              label: LocalizationUtil.translate('nav_learn', language),
            ),
            NavigationDestination(
              icon: const Icon(Icons.quiz),
              selectedIcon: const Icon(Icons.quiz),
              label: LocalizationUtil.translate('nav_progress', language),
              
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              selectedIcon: const Icon(Icons.person),
              label: LocalizationUtil.translate('nav_profile', language),
            ),
            // NavigationDestination(
            //   icon: const Icon(Icons.video_library),
            //   selectedIcon: const Icon(Icons.video_library),
            //   label: LocalizationUtil.translate('nav_gallery', language),
            // ),
          ],
        ),
      ),
    );
  }
}