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

  Future<void> fetchTutorials() async {
    _isLoading = true;
    // notifyListeners(); // Avoid rebuilding immediately if not needed, but good for loading spinners

    try {
      final response = await _apiClient.get('/tutorials');
      if (response is List) {
        _tutorials = response.map<Tutorial>((item) => Tutorial.fromJson(item)).toList();
      } else {
        // Handle case where it might be wrapped in { "data": [...] }
        if (response is Map && response.containsKey('data')) {
             var data = response['data'] as List;
             _tutorials = data.map<Tutorial>((item) => Tutorial.fromJson(item)).toList();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
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

  Future<void> submitQuiz({
    required String userId,
    required String lessonId,
    required Map<String, String> answers,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      // 1. Create the Map directly (Do not use json.encode unless your specific client requires a String)
      final bodyData = {
        "userId": userId,
        "lessonId": lessonId,
        "answers": answers,
      };

      print("Submitting Quiz Data: $bodyData");

      // 2. Call the API
      // Since your client returns a Map automatically, it likely handles json encoding/decoding internally.
      final responseData = await _apiClient.post('/assessment/quiz/submit', bodyData);

      // 3. Handle Success
      // If code reaches here, it means it was successful (200 OK).
      // 'responseData' holds the server response (e.g., {"message": "Success", "score": ...})
      print("Quiz Submitted Successfully: $responseData");

    } catch (e) {
      print("Error submitting quiz: $e");
      // Optional: You can rethrow the error if you want the UI to show a specific SnackBar
      // rethrow; 
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
