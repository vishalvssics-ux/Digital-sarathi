import 'package:sarathi_app/providers/auth_provider.dart';
import 'package:sarathi_app/providers/tutorial_provider.dart';

import '../../widgets/glass_container.dart';
import '../../core/utils/localization_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String? _language;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authUser = context.read<AuthProvider>().user;
      if (authUser?.id != null) {
        _language = authUser?.language;
        // fetchTutorials also updates the report and lesson titles
        context.read<TutorialProvider>().fetchTutorials(
          userId: authUser!.id!,
          lang: _language != null ? _getLangCode(_language!) : null,
        );
      }
    });
  }

  String _getLangCode(String lang) {
    switch (lang) {
      case 'Malayalam': return 'ml';
      case 'Tamil': return 'ta';
      case 'Hindi': return 'hi';
      default: return 'en';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().user;
    
    // Reactive Refresh
    if (authUser != null && authUser.language != _language) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _language = authUser.language;
          });
          context.read<TutorialProvider>().fetchTutorials(
            userId: authUser.id!,
            lang: _language != null ? _getLangCode(_language!) : null,
          );
        }
      });
    }

    final lang = authUser?.language;

    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: Text(
          LocalizationUtil.translate('progress_title', lang), 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<TutorialProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.report == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          
          final data = provider.report;
          
          if (data == null) {
            return Center(child: Text(LocalizationUtil.translate('progress_no_data', lang), style: const TextStyle(color: Colors.white)));
          }

          // Localized titles are available in provider.tutorials if we fetched with lang
          // The report contains titles, but often the default ones.
          // Let's ensure we use the translated titles from tutorials if they match.
          final displayTitles = data.lessonTitles.map((t) {
             try {
                // Find matching tutorial in list to get localized title
                final tut = provider.tutorials.firstWhere((element) => element.originalTitle == t || element.title == t);
                return tut.title;
             } catch (e) {
                return t;
             }
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // Status Section
                _buildStatusCard(data.status, lang),
                const SizedBox(height: 20),
                
                // Statistics Row
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        LocalizationUtil.translate('progress_lessons_done', lang), 
                        "${data.lessonsCompleted}", 
                        Icons.check_circle_outline,
                        Colors.lightBlueAccent
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoCard(
                        LocalizationUtil.translate('progress_avg_score', lang), 
                        data.averageQuizScore.toStringAsFixed(1), 
                        Icons.star_border,
                        Colors.amberAccent
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Lesson List Header
                Text(
                  LocalizationUtil.translate('progress_completed_lessons', lang), 
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                ),
                const SizedBox(height: 12),
                
                // List of Lessons
                if (displayTitles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(LocalizationUtil.translate('progress_no_lessons', lang), style: const TextStyle(color: Colors.white70)),
                  )
                else
                  ...displayTitles.map((title) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.play_lesson, color: Colors.white),
                          const SizedBox(width: 16),
                          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
                        ],
                      ),
                    ),
                  )),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget for the main Status display
  Widget _buildStatusCard(String status, String? lang) {
    final isSuccess = status == "On Track";
    final color = isSuccess ? Colors.greenAccent : Colors.orangeAccent;
    
    final localizedStatus = isSuccess 
        ? LocalizationUtil.translate('status_on_track', lang)
        : LocalizationUtil.translate('status_needs_improvement', lang);
    
    // Localize status if needed, but assuming server might return translated status or keep as is.
    // For now, let's just use the server status but localize the "Overall Status" label.

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        children: [
          Icon(Icons.emoji_events, size: 60, color: color),
          const SizedBox(height: 12),
          Text(
            localizedStatus,
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: color,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: color.withOpacity(0.5),
                  offset: const Offset(0, 0),
                ),
              ]
            ),
          ),
          Text(LocalizationUtil.translate('progress_overall_status', lang), style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // Widget for small statistic cards
  Widget _buildInfoCard(String label, String value, IconData icon, Color iconColor) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
