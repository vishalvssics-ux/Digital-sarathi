// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiClient {
//   static const String baseUrl = "https://sarathi-ai-rust.vercel.app/api";

//   Future<Map<String, String>> _getHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   Future<dynamic> get(String endpoint) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     final headers = await _getHeaders();

//     try {
//       final response = await http.get(url, headers: headers);
//       return _processResponse(response);
//     } catch (e) {
//       throw Exception('Failed to connect to server: $e');
//     }
//   }

//   Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     final headers = await _getHeaders();

//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       return _processResponse(response);
//     } catch (e) {
//       throw Exception('Failed to connect to server: $e');
//     }
//   }

//   Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     final headers = await _getHeaders();

//     try {
//       final response = await http.put(
//         url,
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       return _processResponse(response);
//     } catch (e) {
//       throw Exception('Failed to connect to server: $e');
//     }
//   }

//   Future<dynamic> delete(String endpoint) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     final headers = await _getHeaders();

//     try {
//       final response = await http.delete(url, headers: headers);
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         return true;
//       } else {
//         return _processResponse(response);
//       }
//     } catch (e) {
//       throw Exception('Failed to connect to server: $e');
//     }
//   }

//   dynamic _processResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       if (response.body.isEmpty) return {};
//       try {
//         return jsonDecode(response.body);
//       } catch (e) {
//         return response.body; // Return raw string if not JSON
//       }
//     } else {
//       // Allow handling of 400/401 errors gracefully by returning body or throwing specific exception
//       // processing error body
//       try {
//         final errorBody = jsonDecode(response.body);
//         throw Exception(errorBody['message'] ?? 'Error: ${response.statusCode}');
//       } catch (e) {
//         throw Exception('Error: ${response.statusCode} - ${response.body}');
//       }
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
// Removed SharedPreferences import as it is no longer needed for the token

class ApiClient {
  static const String baseUrl = "https://sarathi-ai-8hk8.onrender.com/api";

  // helper to get headers (No longer async since we don't need to fetch token)
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      // Authorization header removed
    };
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _getHeaders(); // Removed await

    try {
      final response = await http.get(url, headers: headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _getHeaders(); // Removed await

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _getHeaders(); // Removed await

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _getHeaders(); // Removed await

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return _processResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body; // Return raw string if not JSON
      }
    } else {
      // Allow handling of 400/401 errors gracefully by returning body or throwing specific exception
      try {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Error: ${response.statusCode}');
      } catch (e) {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    }
  }
}