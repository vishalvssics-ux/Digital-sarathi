class TutorialStep {
  final int stepNumber;
  final String instruction;

  TutorialStep({
    required this.stepNumber,
    required this.instruction,
  });

  factory TutorialStep.fromJson(Map<String, dynamic> json) {
    return TutorialStep(
      stepNumber: json['stepNumber'] ?? 0,
      instruction: json['instruction'] ?? '',
    );
  }
}

class Tutorial {
  final String? id;
  final String title;
  final String? originalTitle;
  final String category;
  final String description;
  final String language;
  final List<TutorialStep> steps;

  Tutorial({
    this.id,
    required this.title,
    this.originalTitle,
    required this.category,
    required this.description,
    required this.language,
    required this.steps,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    var rawSteps = json['steps'] as List? ?? [];
    List<TutorialStep> parsedSteps = rawSteps.map((i) => TutorialStep.fromJson(i)).toList();

    return Tutorial(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      originalTitle: json['originalTitle'],
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      language: json['language'] ?? 'English',
      steps: parsedSteps,
    );
  }
}

class QuizResponse {
  final String id;
  final String lessonId;
  final List<Question> questions;

  QuizResponse({
    required this.id,
    required this.lessonId,
    required this.questions,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      id: json['_id']?.toString() ?? '',
      lessonId: json['lessonId']?.toString() ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => Question.fromJson(q))
          .toList() ?? [],
    );
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String type;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id']?.toString() ?? '',
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      type: json['type'] ?? 'radio',
    );
  }
}

class AssessmentReport {
  final int lessonsCompleted;
  final List<String> lessonTitles;
  final double averageQuizScore;
  final String status;

  AssessmentReport({
    required this.lessonsCompleted,
    required this.lessonTitles,
    required this.averageQuizScore,
    required this.status,
  });

  factory AssessmentReport.fromJson(Map<String, dynamic> json) {
    return AssessmentReport(
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      lessonTitles: List<String>.from(json['lessonTitles'] ?? []),
      averageQuizScore: (json['averageQuizScore'] ?? 0).toDouble(),
      status: json['status'] ?? 'Unknown',
    );
  }
}
