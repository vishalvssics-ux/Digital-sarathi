import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/quiz/active_quiz_screen.dart';
import '../../providers/tutorial_provider.dart';
import '../../models/tutorial_model.dart';
import '../../widgets/glass_container.dart'; // Import GlassContainer

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorialProvider>().fetchTutorials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Learn & Quiz",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<TutorialProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
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
            return const Center(
              child: Text(
                "No tutorials found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
    
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.tutorials.length,
            itemBuilder: (context, index) {
              final tutorial = provider.tutorials[index];
              return _TutorialCard(tutorial: tutorial);
            },
          );
        },
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final Tutorial tutorial;

  const _TutorialCard({
    super.key,
    required this.tutorial,
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
            title: Text(
              tutorial.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            subtitle: Text(
              "${tutorial.category} • ${tutorial.language}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, color: Colors.white), 
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
                    const Text(
                      "Steps:",
                      style: TextStyle(
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
    
                    Consumer<TutorialProvider>(
                      builder: (context, provider, child) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: provider.isQuizLoading
                              ? null
                              : () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Loading quiz..."),
                                    ),
                                  );
    
                                  await provider.fetchQuiz(tutorial.id!);
    
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
                                  if (provider.currentQuiz != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActiveQuizScreen(
                                          quizData: provider.currentQuiz!,
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
                              : const Icon(Icons.play_arrow),
                          label: Text(
                            provider.isQuizLoading ? "Loading..." : "Take Quiz",
                            style: const TextStyle(fontSize: 16),
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