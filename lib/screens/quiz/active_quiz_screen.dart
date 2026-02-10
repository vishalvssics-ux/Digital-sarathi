// // import 'package:flutter/material.dart';
// // import 'package:sarathi_app/models/tutorial_model.dart';


// // class ActiveQuizScreen extends StatefulWidget {
// //   final QuizResponse quizData;

// //   const ActiveQuizScreen({super.key, required this.quizData});

// //   @override
// //   State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
// // }

// // class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
// //   int _currentIndex = 0;
// //   int _score = 0;
// //   String? _selectedOption;
// //   bool _isAnswerChecked = false;

// //   void _checkAnswer() {
// //     if (_selectedOption == null) return;

// //     final currentQuestion = widget.quizData.questions[_currentIndex];
    
// //     setState(() {
// //       _isAnswerChecked = true;
// //       if (_selectedOption == currentQuestion.correctAnswer) {
// //         _score++;
// //       }
// //     });
// //   }

// //   void _nextQuestion() {
// //     if (_currentIndex < widget.quizData.questions.length - 1) {
// //       setState(() {
// //         _currentIndex++;
// //         _selectedOption = null;
// //         _isAnswerChecked = false;
// //       });
// //     } else {
// //       // Show Result Dialog
// //       showDialog(
// //         context: context,
// //         builder: (ctx) => AlertDialog(
// //           title: const Text("Quiz Completed!"),
// //           content: Text("You scored $_score out of ${widget.quizData.questions.length}"),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(ctx).pop(); // Close dialog
// //                 Navigator.of(context).pop(); // Go back to list
// //               },
// //               child: const Text("Finish"),
// //             )
// //           ],
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final question = widget.quizData.questions[_currentIndex];

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Question ${_currentIndex + 1}/${widget.quizData.questions.length}"),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             // Question Text
// //             Text(
// //               question.questionText,
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 20),
            
// //             // Options
// //             ...question.options.map((option) {
// //               Color tileColor = Colors.transparent;
// //               if (_isAnswerChecked) {
// //                 if (option == question.correctAnswer) {
// //                   tileColor = Colors.green.withOpacity(0.3);
// //                 } else if (option == _selectedOption && option != question.correctAnswer) {
// //                   tileColor = Colors.red.withOpacity(0.3);
// //                 }
// //               }

// //               return Container(
// //                 margin: const EdgeInsets.only(bottom: 8),
// //                 decoration: BoxDecoration(
// //                   color: tileColor,
// //                   borderRadius: BorderRadius.circular(8),
// //                   border: Border.all(color: Colors.grey.shade300)
// //                 ),
// //                 child: RadioListTile<String>(
// //                   title: Text(option),
// //                   value: option,
// //                   groupValue: _selectedOption,
// //                   onChanged: _isAnswerChecked 
// //                     ? null // Disable changing answer after checking
// //                     : (value) {
// //                       setState(() {
// //                         _selectedOption = value;
// //                       });
// //                     },
// //                 ),
// //               );
// //             }),

// //             const Spacer(),

// //             // Action Button
// //             ElevatedButton(
// //               onPressed: _selectedOption == null 
// //                 ? null 
// //                 : (_isAnswerChecked ? _nextQuestion : _checkAnswer),
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(vertical: 16),
// //               ),
// //               child: Text(_isAnswerChecked 
// //                 ? (_currentIndex == widget.quizData.questions.length - 1 ? "Finish" : "Next Question") 
// //                 : "Check Answer"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:sarathi_app/models/tutorial_model.dart';


// class ActiveQuizScreen extends StatefulWidget {
//   final QuizResponse quizData;

//   const ActiveQuizScreen({super.key, required this.quizData});

//   @override
//   State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
// }

// class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
//   int _currentIndex = 0;
//   int _score = 0;
//   String? _selectedOption;
//   bool _isAnswerChecked = false;

//   void _checkAnswer() {
//     if (_selectedOption == null) return;

//     final currentQuestion = widget.quizData.questions[_currentIndex];
    
//     setState(() {
//       _isAnswerChecked = true;
//       if (_selectedOption == currentQuestion.correctAnswer) {
//         _score++;
//       }
//     });
//   }

//   void _nextQuestion() {
//     if (_currentIndex < widget.quizData.questions.length - 1) {
//       setState(() {
//         _currentIndex++;
//         _selectedOption = null;
//         _isAnswerChecked = false;
//       });
//     } else {
//       _showResultDialog();
//     }
//   }

//   void _showResultDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent clicking outside to close
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Column(
//           children: [
//             Icon(Icons.emoji_events, size: 50, color: Colors.orange),
//             SizedBox(height: 10),
//             Text("Quiz Completed!"),
//           ],
//         ),
//         content: Text(
//           "You scored $_score out of ${widget.quizData.questions.length}",
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 18),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop(); // Close dialog
//               Navigator.of(context).pop(); // Go back to tutorial list
//             },
//             child: const Text("Back to Lessons", style: TextStyle(fontSize: 16)),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Safety check for empty questions
//     if (widget.quizData.questions.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Quiz")),
//         body: const Center(child: Text("No questions available.")),
//       );
//     }

//     final question = widget.quizData.questions[_currentIndex];
//     final totalQuestions = widget.quizData.questions.length;
//     final progress = (_currentIndex + 1) / totalQuestions;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Quiz Assessment"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // 1. Progress Bar
//             LinearProgressIndicator(
//               value: progress,
//               backgroundColor: Colors.grey[200],
//               color: Colors.blue,
//               minHeight: 8,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Question ${_currentIndex + 1} of $totalQuestions",
//               style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // 2. Question Text
//             Text(
//               question.questionText,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
//             ),
//             const SizedBox(height: 24),

//             // 3. Options List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: question.options.length,
//                 itemBuilder: (context, index) {
//                   final option = question.options[index];
//                   return _buildOptionTile(option, question.correctAnswer);
//                 },
//               ),
//             ),

//             // 4. Action Button
//             SizedBox(
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _selectedOption == null 
//                   ? null // Disable if nothing selected
//                   : (_isAnswerChecked ? _nextQuestion : _checkAnswer),
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text(
//                   _isAnswerChecked 
//                     ? (_currentIndex == totalQuestions - 1 ? "Finish Quiz" : "Next Question")
//                     : "Check Answer",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile(String option, String correctAnswer) {
//     Color borderColor = Colors.grey.shade300;
//     Color backgroundColor = Colors.white;
//     IconData? icon;
//     Color iconColor = Colors.transparent;

//     if (_isAnswerChecked) {
//       if (option == correctAnswer) {
//         // Correct Answer -> Green
//         borderColor = Colors.green;
//         backgroundColor = Colors.green.withOpacity(0.1);
//         icon = Icons.check_circle;
//         iconColor = Colors.green;
//       } else if (option == _selectedOption) {
//         // Wrong Selection -> Red
//         borderColor = Colors.red;
//         backgroundColor = Colors.red.withOpacity(0.1);
//         icon = Icons.cancel;
//         iconColor = Colors.red;
//       }
//     } else {
//       if (option == _selectedOption) {
//         // Selected (before checking) -> Blue
//         borderColor = Colors.blue;
//         backgroundColor = Colors.blue.withOpacity(0.05);
//       }
//     }

//     return GestureDetector(
//       onTap: _isAnswerChecked 
//         ? null // Disable tap after checking
//         : () {
//           setState(() {
//             _selectedOption = option;
//           });
//         },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           border: Border.all(color: borderColor, width: 2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 option,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//             if (icon != null)
//               Icon(icon, color: iconColor)
//             else
//               Radio<String>(
//                 value: option,
//                 groupValue: _selectedOption,
//                 onChanged: _isAnswerChecked ? null : (val) {
//                   setState(() {
//                     _selectedOption = val;
//                   });
//                 },
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:sarathi_app/models/tutorial_model.dart';

import 'package:sarathi_app/providers/tutorial_provider.dart'; // Import Provider

class ActiveQuizScreen extends StatefulWidget {
  final QuizResponse quizData;

  const ActiveQuizScreen({super.key, required this.quizData});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswerChecked = false;
  
  // 1. ADD THIS: To store answers mapped to Question IDs
  final Map<String, String> _answersToSubmit = {}; 

  void _checkAnswer() {
    if (_selectedOption == null) return;

    final currentQuestion = widget.quizData.questions[_currentIndex];
    
    // 2. ADD THIS: Store the answer for API submission
    _answersToSubmit[currentQuestion.id] = _selectedOption!;

    setState(() {
      _isAnswerChecked = true;
      if (_selectedOption == currentQuestion.correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.quizData.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _isAnswerChecked = false;
      });
    } else {
      // 3. CHANGE THIS: Instead of showing dialog directly, submit first
      _submitAndFinish();
    }
  }

  // 4. ADD THIS: Function to call API and then show dialog
  Future<void> _submitAndFinish() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // TODO: Replace with actual User ID from your Auth Provider
    const String userId = "6958d283084e431c490edf8d"; 

    try {
      await context.read<TutorialProvider>().submitQuiz(
        userId: userId,
        lessonId: widget.quizData.lessonId,
        answers: _answersToSubmit,
      );
    } catch (e) {
      print("Submission error handled silently in UI: $e");
    }

    // Remove loading indicator
    if (mounted) Navigator.pop(context);

    // Show result dialog
    if (mounted) _showResultDialog();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.emoji_events, size: 50, color: Colors.orange),
            SizedBox(height: 10),
            Text("Quiz Completed!"),
          ],
        ),
        content: Text(
          "You scored $_score out of ${widget.quizData.questions.length}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to tutorial list
            },
            child: const Text("Back to Lessons", style: TextStyle(fontSize: 16)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizData.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("No questions available.")),
      );
    }

    final question = widget.quizData.questions[_currentIndex];
    final totalQuestions = widget.quizData.questions.length;
    final progress = (_currentIndex + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Assessment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Text(
              "Question ${_currentIndex + 1} of $totalQuestions",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  return _buildOptionTile(option, question.correctAnswer);
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedOption == null 
                  ? null 
                  : (_isAnswerChecked ? _nextQuestion : _checkAnswer),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _isAnswerChecked 
                    ? (_currentIndex == totalQuestions - 1 ? "Finish Quiz" : "Next Question")
                    : "Check Answer",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(String option, String correctAnswer) {
    Color borderColor = Colors.grey.shade300;
    Color backgroundColor = Colors.white;
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (_isAnswerChecked) {
      if (option == correctAnswer) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        icon = Icons.check_circle;
        iconColor = Colors.green;
      } else if (option == _selectedOption) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        icon = Icons.cancel;
        iconColor = Colors.red;
      }
    } else {
      if (option == _selectedOption) {
        borderColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.05);
      }
    }

    return GestureDetector(
      onTap: _isAnswerChecked 
        ? null 
        : () {
          setState(() {
            _selectedOption = option;
          });
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(option, style: const TextStyle(fontSize: 16)),
            ),
            if (icon != null)
              Icon(icon, color: iconColor)
            else
              Radio<String>(
                value: option,
                groupValue: _selectedOption,
                onChanged: _isAnswerChecked ? null : (val) {
                  setState(() {
                    _selectedOption = val;
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}