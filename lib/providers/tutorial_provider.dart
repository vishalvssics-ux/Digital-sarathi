import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show post;
import '../core/services/api_client.dart';
import '../models/tutorial_model.dart';

class TutorialProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Tutorial> _tutorials = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  
  bool _isQuizLoading = false;
  QuizResponse? _currentQuiz; // 1. Store the quiz here
  String? _quizError;         // 2. Store errors here

  bool get isQuizLoading => _isQuizLoading;
  QuizResponse? get currentQuiz => _currentQuiz;
  String? get quizError => _quizError;

  List<Tutorial> get tutorials => _tutorials;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AssessmentReport? _report;
  AssessmentReport? get report => _report;

  Future<void> fetchTutorials({String? userId, String? lang}) async {
    _isLoading = true;
    _errorMessage = null; // Clear previous error
    notifyListeners();

    try {
      String endpoint = '/tutorials';
      List<String> params = [];
      if (userId != null && userId.isNotEmpty) {
        params.add('userId=$userId');
      }
      if (lang != null && lang.isNotEmpty) {
        params.add('lang=$lang');
      }
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await _apiClient.get(endpoint);
      if (response is List) {
        _tutorials = response.map<Tutorial>((item) => Tutorial.fromJson(item)).toList();
      } else {
        // Handle case where it might be wrapped in { "data": [...] }
        if (response is Map && response.containsKey('data')) {
             var data = response['data'] as List;
             _tutorials = data.map<Tutorial>((item) => Tutorial.fromJson(item)).toList(); 
        }
      }

      if (userId != null) {
        await fetchProgressReport(userId, lang: lang);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProgressReport(String userId, {String? lang}) async {
    try {
      String endpoint = '/assessment/report/$userId';
      if (lang != null && lang.isNotEmpty) {
        endpoint += '?lang=$lang';
      }
      final responseData = await _apiClient.get(endpoint);
      _report = AssessmentReport.fromJson(responseData);
      notifyListeners();
    } catch (e) {
      print("Error fetching progress report: $e");
    }
  }
// inside lib/providers/tutorial_provider.dart

Future<void> fetchQuiz(String lessonId, String userId) async {
  _isQuizLoading = true;
  _quizError = null;
  _currentQuiz = null;
  notifyListeners();

  try {
    print("Fetching quiz for lesson: $lessonId, userId: $userId");

    // Inclusion of userId as query parameter
    final responseData = await _apiClient.get('/assessment/quiz/$lessonId?userId=$userId');

    print("API Response Data: $responseData");

    _currentQuiz = QuizResponse.fromJson(responseData);

  } catch (e) {
    print("Error fetching quiz: $e");
    _quizError = "Failed to load quiz. Please try again.";
  } finally {
    _isQuizLoading = false;
    notifyListeners();
  }
}
// inside TutorialProvider

  Future<Map<String, dynamic>?> submitQuiz({
    required String userId,
    required String lessonId,
    required Map<String, String> answers,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final bodyData = {
        "userId": userId,
        "lessonId": lessonId,
        "answers": answers,
      };

      print("Submitting Quiz Data: $bodyData");

      final responseData = await _apiClient.post('/assessment/quiz/submit', bodyData);

      print("Quiz Submitted Successfully: $responseData");
      
      // Auto refresh report after submission
      await fetchProgressReport(userId);
      
      return responseData;

    } catch (e) {
      print("Error submitting quiz: $e");
      rethrow; 
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
