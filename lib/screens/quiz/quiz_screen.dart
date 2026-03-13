import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import 'package:sarathi_app/models/tutorial_model.dart';
import 'package:sarathi_app/providers/auth_provider.dart';
import 'package:sarathi_app/providers/tutorial_provider.dart';
import 'package:sarathi_app/screens/quiz/active_quiz_screen.dart';

import '../../widgets/glass_container.dart';
import '../../core/utils/localization_util.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String? _language;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;
      if (user != null) {
        _language = user.language;
        context.read<TutorialProvider>().fetchTutorials(
          userId: user.id,
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
            userId: authUser.id,
            lang: _language != null ? _getLangCode(_language!) : null,
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          LocalizationUtil.translate('quiz_title', context.watch<AuthProvider>().user?.language),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<TutorialProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.tutorials.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
    
          if (provider.tutorials.isEmpty) {
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  "Error: ${provider.errorMessage}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(
              child: Text(
                LocalizationUtil.translate('quiz_no_tutorials', context.watch<AuthProvider>().user?.language),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
    
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.tutorials.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildProgressSummary(provider);
              }
              final tutorial = provider.tutorials[index - 1];
              final isCompleted = provider.report?.lessonTitles.contains(tutorial.title) ?? false;
              return _TutorialCard(tutorial: tutorial, isCompleted: isCompleted);
            },
          );
        },
      ),
    );
  }

  Widget _buildProgressSummary(TutorialProvider provider) {
    final report = provider.report;
    if (report == null) return const SizedBox.shrink();

    final totalLessons = provider.tutorials.length;
    final progress = totalLessons > 0 ? report.lessonsCompleted / totalLessons : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationUtil.translate('quiz_overall_progress', context.watch<AuthProvider>().user?.language),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                color: Colors.amber,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              LocalizationUtil.translate(
                'quiz_completed_summary', 
                context.watch<AuthProvider>().user?.language,
                args: {'done': '${report.lessonsCompleted}', 'total': '$totalLessons'}
              ),
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final Tutorial tutorial;
  final bool isCompleted;

  const _TutorialCard({
    super.key,
    required this.tutorial,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    tutorial.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                ),
                if (isCompleted)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                  ),
              ],
            ),
            subtitle: Text(
              "${tutorial.category} • ${tutorial.language}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.greenAccent.withOpacity(0.2) : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.school, 
                color: isCompleted ? Colors.greenAccent : Colors.white,
              ), 
            ),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white70,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tutorial.description,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    Text(
                      LocalizationUtil.translate('quiz_steps', context.watch<AuthProvider>().user?.language),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...tutorial.steps.map((step) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: Text(
                                  "${step.stepNumber}",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(step.instruction, style: const TextStyle(color: Colors.white70))),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
    
                    Consumer2<TutorialProvider, AuthProvider>(
                      builder: (context, provider, authProvider, child) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompleted ? Colors.greenAccent.withOpacity(0.1) : Colors.white,
                            foregroundColor: isCompleted ? Colors.greenAccent : Theme.of(context).primaryColor,
                            side: isCompleted ? const BorderSide(color: Colors.greenAccent) : null,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: provider.isQuizLoading
                              ? null
                              : () async {
                                  final userId = authProvider.user?.id ?? "6958d3ff8147f047d27ed171";
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Loading quiz..."),
                                    ),
                                  );
    
                                  await provider.fetchQuiz(tutorial.id!, userId);
    
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
                                  if (provider.currentQuiz != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActiveQuizScreen(
                                          quizData: provider.currentQuiz!,
                                          userId: userId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            provider.quizError ?? "Failed to load quiz."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          icon: provider.isQuizLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.deepPurple,
                                  ),
                                )
                              : Icon(isCompleted ? Icons.replay : Icons.play_arrow),
                          label: Text(
                            provider.isQuizLoading 
                              ? "Loading..." 
                              : (isCompleted 
                                  ? LocalizationUtil.translate('quiz_retake', authProvider.user?.language) 
                                  : LocalizationUtil.translate('quiz_start', authProvider.user?.language)),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

