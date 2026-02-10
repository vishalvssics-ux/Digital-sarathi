import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarathi_app/screens/quiz/active_quiz_screen.dart';
import '../../providers/tutorial_provider.dart';
import '../../models/tutorial_model.dart'; // Add this import

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
      appBar: AppBar(title: const Text("Learn & Quiz")),
      body: Consumer<TutorialProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.tutorials.isEmpty) {
             if(provider.errorMessage != null){
                 return Center(child: Text("Error: ${provider.errorMessage}"));
             }
             return const Center(child: Text("No tutorials found."));
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

// class _TutorialCard extends StatelessWidget {
//   final Tutorial tutorial;

//   const _TutorialCard({required this.tutorial});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 2,
//       child: ExpansionTile(
//         title: Text(
//             tutorial.title,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//             "${tutorial.category} • ${tutorial.language}",
//             style: TextStyle(color: Colors.grey[600], fontSize: 12),
//         ),
//         leading: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.1),
//                 shape: BoxShape.circle
//             ),
//             child: const Icon(Icons.school, color: Colors.blue),
//         ),
//         children: [
//             Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                         Text(tutorial.description, style: const TextStyle(color: Colors.black87)),
//                         const SizedBox(height: 12),
//                         const Divider(),
//                         const Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 8),
//                         ...tutorial.steps.map((step) => Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                     CircleAvatar(
//                                         radius: 10,
//                                         backgroundColor: Colors.grey[200],
//                                         child: Text("${step.stepNumber}", style: const TextStyle(fontSize: 10, color: Colors.black)),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Expanded(child: Text(step.instruction)),
//                                 ],
//                             ),
//                         )),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                             onPressed: () {
                              
//                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quiz module starting...")));
//                             }, 
//                             icon: const Icon(Icons.play_arrow),
//                             label: const Text("Take Quiz"),
//                         )
//                     ],
//                 ),
//             )
//         ],
//       ),
//     );
//   }
// }
// Update imports in your main file


// class _TutorialCard extends StatelessWidget {
//   final Tutorial tutorial;

//   const _TutorialCard({required this.tutorial});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // ... existing UI code ...
//       child: ExpansionTile(
//         // ... existing UI code ...
//         title: Text(
//           tutorial.title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // ... existing description and steps ...
                
//                 const SizedBox(height: 16),
                
//                 // UPDATED BUTTON LOGIC
//                 Consumer<TutorialProvider>(
//                   builder: (context, provider, child) {
//                     return ElevatedButton.icon(
//                       onPressed: provider.isQuizLoading 
//                         ? null 
//                         : () async {
//                             // Show loading snackbar
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text("Loading quiz...")),
//                             );

//                             // 1. Call the API using the tutorial ID
//                             // Ensure tutorial.id is the lessonId (e.g. "695b863fb3f58a01b50f9d0f")
//                             final quiz = await provider.fetchQuiz(tutorial.id!);

//                             // 2. Navigate if successful
//                             if (quiz != null && context.mounted) {
//                                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ActiveQuizScreen(quizData: quiz),
//                                   ),
//                                 );
//                             } else if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("Failed to load quiz. Try again.")),
//                                 );
//                             }
//                         }, 
//                       icon: provider.isQuizLoading 
//                         ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
//                         : const Icon(Icons.play_arrow),
//                       label: Text(provider.isQuizLoading ? "Loading..." : "Take Quiz"),
//                     );
//                   }
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
class _TutorialCard extends StatelessWidget {
  final Tutorial tutorial;

  const _TutorialCard({required this.tutorial});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          tutorial.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${tutorial.category} • ${tutorial.language}",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.school, color: Colors.blue),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tutorial.description, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 12),
                const Divider(),
                const Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...tutorial.steps.map((step) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey[200],
                            child: Text("${step.stepNumber}",
                                style: const TextStyle(fontSize: 10, color: Colors.black)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(step.instruction)),
                        ],
                      ),
                    )),
                const SizedBox(height: 16),
                
                // --- UPDATED BUTTON LOGIC STARTS HERE ---
                Consumer<TutorialProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton.icon(
                      onPressed: provider.isQuizLoading
                          ? null
                          : () async {
                              // 1. Show User Feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Loading quiz...")),
                              );

                              // 2. Call the void function (Wait for it to finish)
                              await provider.fetchQuiz(tutorial.id!);

                              // 3. Check if widget is still on screen
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();

                              // 4. Check Provider State for Success/Failure
                              if (provider.currentQuiz != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // Pass the data stored in the provider
                                    builder: (context) => ActiveQuizScreen(
                                      quizData: provider.currentQuiz!,
                                    ),
                                  ),
                                );
                              } else {
                                // Show error from provider
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(provider.quizError ?? "Failed to load quiz."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      icon: provider.isQuizLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.play_arrow),
                      label: Text(provider.isQuizLoading ? "Loading..." : "Take Quiz"),
                    );
                  },
                )
                // --- UPDATED BUTTON LOGIC ENDS HERE ---
              ],
            ),
          )
        ],
      ),
    );
  }
}