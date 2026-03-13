// import 'package:flutter/material.dart';
// import '../chat/chat_screen.dart';
// import '../quiz/quiz_screen.dart';
// import '../progress/progress_screen.dart';
// import '../profile/profile_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const ChatScreen(),
//     const QuizScreen(),
//     const ProgressScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _currentIndex,
//         onDestinationSelected: (index) => setState(() => _currentIndex = index),
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.mic_none_outlined),
//             selectedIcon: Icon(Icons.mic),
//             label: 'Chat',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.menu_book_outlined),
//             selectedIcon: Icon(Icons.menu_book),
//             label: 'Learn', // "Quiz" mapped to Learn/Tutorials
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.emoji_events_outlined),
//             selectedIcon: Icon(Icons.emoji_events),
//             label: 'Progress',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../widgets/glass_scaffold.dart';
import '../chat/chat_screen.dart';

import '../quiz/quiz_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final language = context.watch<AuthProvider>().user?.language;
    
    return GlassScaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return const IconThemeData(color: Colors.white70);
          }),
          indicatorColor: Colors.white.withOpacity(0.2), 
        ),
        child: NavigationBar(
          backgroundColor:  Color(0xFF1A1A5E),
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
          ],
        ),
      ),
    );
  }
}