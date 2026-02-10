import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/api_client.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.post('/users/login', {
        'identifier': email,
        'password': password,
      });

      // The response structure is: { "message": "...", "user": { ... } }
      // There is no token in the response provided.
      if (response != null && response['user'] != null) {
        
        // Directly parse the user object from the response
        _user = User.fromJson(response['user']);
        
        // Since there is no token to save, we simply notify listeners that login is done.
        // If you need to persist the session, you might need to save the user._id locally
        // or rely on cookies if the server sets them.
        
        notifyListeners();
      } else {
        _errorMessage = "Login failed: User data not found in response";
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> login(String email, String password) async {
  //   _setLoading(true);
  //   _clearError();

  //   try {
  //     final response = await _apiClient.post('/users/login', {
  //       'identifier': email,
  //       'password': password,
  //     });

  //     // Assuming response contains token and user details
  //     if (response != null && response['token'] != null) {
  //       final token = response['token'];
  //       await _saveToken(token);
        
  //       // Fetch profile if user data isn't fully in login response
  //       // Or parse user from response
  //       // For now, let's assume we need to fetch profile or use what's returned
  //       // Let's assume the response has the user object or we fetch it.
  //       // If login returns just token, we'd do:
  //       // await fetchUserProfile(); 
        
  //       // Based on Postman, let's assume we might need to fetch profile or it returns it.
  //       // Let's safe code: if response has user data use it, else fetch.
  //       if (response['user'] != null) {
  //            _user = User.fromJson(response['user']);
  //       } else {
  //            // If we don't have ID, we can't fetch profile easily unless /profile/me exists
  //            // Postman shows /users/profile/:id
  //            // We'll need the ID from the login response at least.
  //            if(response['_id'] != null || response['id'] != null){
  //                final userId = response['_id'] ?? response['id'];
  //                await fetchUserProfile(userId);
  //            }
  //       }
        
  //       if(_user == null && response['fullName'] != null){
  //            // Flattened response
  //            _user = User.fromJson(response);
  //       }

  //       notifyListeners();
  //     } else {
  //       _errorMessage = "Login failed: Invalid response";
  //     }
  //   } catch (e) {
  //     _errorMessage = e.toString().replaceAll("Exception:", "").trim();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> register(User user, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final data = user.toJson();
      data['password'] = password;
      data['confirmPassword'] = password; // Assuming validation passed

      await _apiClient.post('/users/register', data);
      
      // Auto login or ask user to login?
      // For now, let's just return success and user can login.
    } catch (e) {
        _errorMessage = e.toString().replaceAll("Exception:", "").trim();
        rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final response = await _apiClient.get('/users/profile/$userId');
      if (response != null) {
        _user = User.fromJson(response);
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
