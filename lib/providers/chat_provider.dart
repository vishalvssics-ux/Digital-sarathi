import 'package:flutter/material.dart';
import '../core/services/api_client.dart';
import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> _suggestions = [];
  
  List<ChatMessage> get messages => _messages;
  List<dynamic> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String userId, String text) async {
    _messages.add(ChatMessage(role: 'user', content: text, timestamp: DateTime.now()));
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.post('/users/voice-chat', {
        'userId': userId,
        'textInput': text,
      });

      // Assuming response contains the AI reply
      // The Postman example doesn't show the exact response structure clearly for the text, 
      // but usually it's { "response": "..." } or similar.
      // We will handle generic JSON response.
      
      String aiResponseText = "I didn't understand that.";
      List<String> steps = [];

      if (response is Map) {
          if (response.containsKey('aiSaid')) aiResponseText = response['aiSaid'];
          else if (response.containsKey('response')) aiResponseText = response['response'];
          
          if (response.containsKey('steps') && response['steps'] is List) {
            steps = List<String>.from(response['steps']);
          }
      }

      _messages.add(ChatMessage(
        role: 'model', 
        content: aiResponseText, 
        timestamp: DateTime.now(),
        steps: steps
      ));

    } catch (e) {
      _messages.add(ChatMessage(role: 'model', content: "Error: Failed to get response.", timestamp: DateTime.now()));
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.get('/users/history/$userId');
      if (response != null && response['history'] is List) {
        final historyList = response['history'] as List;
        _messages = [];
        // React code: historyRes.data.history.reverse().forEach...
        // We will just process them in order they come (usually chronological) or reverse if needed.
        // Assuming API returns newest last or first? React reverses them, then pushes.
        // If React reverses, then it implies API returns Newest First? Or Oldest First?
        // Let's assume we want them in order.
        
        for (var item in historyList.reversed) {
             _messages.add(ChatMessage(
               role: 'user', 
               content: item['originalText'] ?? '', 
               timestamp: DateTime.now() // formatting needed if date provided
             ));
             _messages.add(ChatMessage(
               role: 'model', 
               content: item['translatedResponse'] ?? '', 
               timestamp: DateTime.now()
             ));
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchSuggestions(String lang) async {
    try {
      final langMap = { "Malayalam": "ml", "Tamil": "ta", "Hindi": "hi", "English": "en" };
      final langCode = langMap[lang] ?? "en";
      final response = await _apiClient.get('/tutorials?lang=$langCode');
      if (response is List) {
        _suggestions = response;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  Future<void> clearHistory(String userId) async {
    try {
      await _apiClient.delete('/users/history/$userId');
      _messages = [ChatMessage(role: 'model', content: "History cleared.", timestamp: DateTime.now())];
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to clear history: $e";
      notifyListeners();
    }
  }

  void clearChat() {
      _messages = [];
      notifyListeners();
  }
}
