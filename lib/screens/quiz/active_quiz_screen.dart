import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarathi_app/models/tutorial_model.dart';
import 'package:sarathi_app/providers/tutorial_provider.dart';
import '../../widgets/glass_scaffold.dart';
import '../../widgets/glass_container.dart';

class ActiveQuizScreen extends StatefulWidget {
  final QuizResponse quizData;
  final String userId;

  const ActiveQuizScreen({super.key, required this.quizData, required this.userId});

  @override
  State<ActiveQuizScreen> createState() => _ActiveQuizScreenState();
}

class _ActiveQuizScreenState extends State<ActiveQuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswerChecked = false;
  
  final Map<String, String> _answersToSubmit = {}; 

  void _checkAnswer() {
    if (_selectedOption == null) return;

    final currentQuestion = widget.quizData.questions[_currentIndex];
    
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
      _submitAndFinish();
    }
  }

  Future<void> _submitAndFinish() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    Map<String, dynamic>? result;
    try {
      result = await context.read<TutorialProvider>().submitQuiz(
        userId: widget.userId,
        lessonId: widget.quizData.lessonId,
        answers: _answersToSubmit,
      );
    } catch (e) {
      debugPrint("Submission error handled in UI: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save score: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) Navigator.pop(context);

    if (mounted) _showResultDialog(result);
  }

  void _showResultDialog(Map<String, dynamic>? result) {
    final serverMessage = result?['message'] ?? (result != null ? "Score added successfully!" : "Quiz completed!");
    final serverPoints = result?['points'] ?? result?['score'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A5E).withOpacity(0.9), // Dark glass
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.2))),
        title: Column(
          children: [
            const Icon(Icons.emoji_events, size: 50, color: Colors.amber),
            const SizedBox(height: 10),
            Text(result != null ? "Great Job!" : "Quiz Completed!", style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "You scored $_score out of ${widget.quizData.questions.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            if (serverPoints != null) ...[
                const SizedBox(height: 8),
                Text(
                  "+$serverPoints Points added to your profile",
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
            ],
            const SizedBox(height: 16),
            Text(
              serverMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
                Navigator.of(context).pop(); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1A1A5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Continue to Lessons", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizData.questions.isEmpty) {
      return GlassScaffold(
        appBar: AppBar(
          title: const Text("Quiz", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: Text("No questions available.", style: TextStyle(color: Colors.white))),
      );
    }

    final question = widget.quizData.questions[_currentIndex];
    final totalQuestions = widget.quizData.questions.length;
    final progress = (_currentIndex + 1) / totalQuestions;

    return GlassScaffold(
      appBar: AppBar(
        title: const Text("Quiz Assessment", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                color: Colors.amber, // Stand out color
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentIndex + 1} of $totalQuestions",
                  style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Question Text
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.questionText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Options List
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  return _buildOptionTile(option, question.correctAnswer);
                },
              ),
            ),

            // 4. Action Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedOption == null 
                  ? null 
                  : (_isAnswerChecked ? _nextQuestion : _checkAnswer),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Colors.white.withOpacity(0.3),
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
    Color borderColor = Colors.white.withOpacity(0.2);
    Color backgroundColor = Colors.white.withOpacity(0.05);
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (_isAnswerChecked) {
      if (option == correctAnswer) {
        // Correct -> Green styled
        borderColor = Colors.greenAccent;
        backgroundColor = Colors.green.withOpacity(0.2);
        icon = Icons.check_circle;
        iconColor = Colors.greenAccent;
      } else if (option == _selectedOption) {
        // Wrong -> Red styled
        borderColor = Colors.redAccent;
        backgroundColor = Colors.red.withOpacity(0.2);
        icon = Icons.cancel;
        iconColor = Colors.redAccent;
      }
    } else {
      if (option == _selectedOption) {
        // Selected -> White/Blue styled
        borderColor = Colors.white;
        backgroundColor = Colors.white.withOpacity(0.2);
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
      child: Container( // Using Container directly for custom border checking state, but could use GlassContainer with custom border
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
              child: Text(
                option,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            if (icon != null)
              Icon(icon, color: iconColor)
            else
              Radio<String>(
                value: option,
                groupValue: _selectedOption,
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                    }
                    return Colors.white70;
                }),
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