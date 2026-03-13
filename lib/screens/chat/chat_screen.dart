// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // Keep dio for API calls
// import 'package:line_icons/line_icons.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../core/utils/localization_util.dart';

// // --- Data Model ---
// class ChatMessage {
//   final String sender;
//   final String text;
//   final List<String> steps;

//   ChatMessage({
//     required this.sender,
//     required this.text,
//     this.steps = const [],
//   });
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _inputController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   final stt.SpeechToText _speech = stt.SpeechToText();

//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/",
//     connectTimeout: const Duration(seconds: 10),
//     receiveTimeout: const Duration(seconds: 20),
//   ));

//   bool _isListening = false;
//   bool _isLoading = false;
//   List<dynamic> _suggestions = [];

//   late String _userId;
//   late String _userName;
//   late String _language;

//   @override
//   void initState() {
//     super.initState();
//     final authUser = context.read<AuthProvider>().user;
//     _userId = authUser?.id ?? "guest";
//     _userName = authUser?.fullName ?? "User";
//     _language = authUser?.language ?? "English";

//     _initSpeech();
//     _initializeChat();
//   }

//   void _initSpeech() async {
//     try {
//       await _speech.initialize(
//         onError: (e) => debugPrint("Speech Error: $e"),
//         onStatus: (status) => debugPrint("Speech Status: $status"),
//       );
//     } catch (e) {
//       debugPrint("Speech init failed: $e");
//     }
//   }

//   void _initializeChat() async {
//     await _fetchSuggestions();
//     await _fetchHistory();
//   }

//   // --- PARSING LOGIC ---
//   ChatMessage _parseResponseData(Map<String, dynamic> data) {
//     String mainText = data['aiSaid'] ?? data['response'] ?? data['translatedResponse'] ?? "";
//     List<String> stepsList = [];

//     if (data['steps'] != null && data['steps'] is List) {
//       stepsList = List<String>.from(data['steps']);
//     } else if (mainText.contains('[स्प्लिट]')) {
//       List<String> parts = mainText.split('[स्प्लिट]');
//       mainText = parts[0].trim();
//       if (parts.length > 1) {
//         stepsList = parts.sublist(1).map((s) => s.trim()).toList();
//       }
//     }

//     return ChatMessage(sender: 'ai', text: mainText, steps: stepsList);
//   }

//   Future<void> _fetchSuggestions() async {
//     try {
//       final res = await _dio.get('tutorials', queryParameters: {
//         'userId': _userId,
//       });
//       if (mounted) setState(() => _suggestions = res.data ?? []);
//     } catch (e) {
//       debugPrint("Suggestions Error: $e");
//     }
//   }

//   Future<void> _fetchHistory() async {
//     try {
//       final res = await _dio.get('users/history/$_userId');
//       if (res.data != null && res.data['history'] != null) {
//         List history = res.data['history'];
//         if (mounted) {
//           setState(() {
//             _messages.clear();
//             for (var chat in history.reversed) {
//               _messages.add(ChatMessage(sender: 'user', text: chat['originalText'] ?? ''));
//               _messages.add(_parseResponseData(chat));
//             }
//           });
//           _scrollToBottom();
//         }
//       } else {
//         _addWelcomeMessage();
//       }
//     } catch (e) {
//       if (mounted && _messages.isEmpty) _addWelcomeMessage();
//     }
//   }

//   void _addWelcomeMessage() {
//     if (mounted) {
//       setState(() {
//         _messages.add(ChatMessage(
//             sender: 'ai',
//             text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"));
//       });
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   // --- Speech Logic ---
//   void _toggleListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       if (mounted) setState(() => _isListening = false);

//       if (_inputController.text.trim().isNotEmpty) {
//         await Future.delayed(const Duration(milliseconds: 500));
//         _sendMessage(_inputController.text);
//       }
//     } else {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);

//         String localeId = "en_US";
//         if (_language == "Hindi") localeId = "hi_IN";
//         if (_language == "Malayalam") localeId = "ml_IN";
//         if (_language == "Tamil") localeId = "ta_IN";

//         _speech.listen(
//           localeId: localeId,
//           onResult: (val) {
//             setState(() {
//               _inputController.text = val.recognizedWords;
//               _inputController.selection = TextSelection.fromPosition(
//                   TextPosition(offset: _inputController.text.length));
//             });
//           },
//         );
//       } else {
//         _showError("Speech recognition denied or not available");
//         if (await Permission.microphone.isPermanentlyDenied) {
//           openAppSettings();
//         }
//       }
//     }
//   }

//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;

//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     }

//     if (mounted) {
//       setState(() {
//         _messages.add(ChatMessage(sender: 'user', text: text));
//         _isLoading = true;
//         _inputController.clear();
//       });
//       _scrollToBottom();
//     }

//     try {
//       final res = await _dio.post('users/voice-chat', data: {
//         "userId": _userId,
//         "textInput": text
//       });

//       if (mounted) {
//         setState(() {
//           _messages.add(_parseResponseData(res.data));
//         });
//         _scrollToBottom();
//       }
//     } catch (e) {
//       _showError("Connection error. Check internet.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _clearHistory() async {
//     try {
//       await _dio.delete('users/history/$_userId');
//       if (mounted) {
//         setState(() {
//           _messages.clear();
//           _addWelcomeMessage();
//         });
//       }
//     } catch (e) {
//       _showError("Failed to clear history.");
//     }
//   }

//   void _showError(String msg) {
//     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//     final authUser = context.watch<AuthProvider>().user;
//     if (authUser != null && authUser.language != _language) {
//       _language = authUser.language ?? "English";
//       _initializeChat(); // Re-fetch to get suggestions/history in new language
//     }

//     return Scaffold(
//       backgroundColor: Colors.transparent, // Transparent for GlassScaffold parent
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Digital Sarathi",
//                 style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//             Text(
//               "$_language ${LocalizationUtil.translate('nav_chat', _language)}",
//               style: const TextStyle(fontSize: 12, color: Colors.white70)
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//               onPressed: _clearHistory,
//               icon: const Icon(LineIcons.trash, color: Colors.white)),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(16),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final m = _messages[index];
//                 return _buildChatBubble(m);
//               },
//             ),
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text("Thinking...",
//                   style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white70,
//                       fontStyle: FontStyle.italic)),
//             ),
      
//           // Suggestions
//           if (!_isListening && _suggestions.isNotEmpty)
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 itemCount:
//                     _suggestions.length > 10 ? 10 : _suggestions.length,
//                 itemBuilder: (context, index) {
//                   final title = _suggestions[index] is Map
//                       ? _suggestions[index]['title']
//                       : _suggestions[index].toString();
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: ActionChip(
//                       label: Text(title,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 13)),
//                       backgroundColor: Colors.white.withOpacity(0.1),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: BorderSide(color: Colors.white.withOpacity(0.2))),
//                       onPressed: () => _sendMessage(title),
//                     ),
//                   );
//                 },
//               ),
//             ),
      
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }

//   Widget _buildChatBubble(ChatMessage m) {
//     bool isUser = m.sender == 'user';
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(14),
//         constraints:
//             BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
//         decoration: BoxDecoration(
//           color: isUser ? Theme.of(context).primaryColor.withOpacity(0.4) : Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: isUser
//                 ? const Radius.circular(18)
//                 : const Radius.circular(4),
//             bottomRight: isUser
//                 ? const Radius.circular(4)
//                 : const Radius.circular(18),
//           ),
//           border: Border.all(color: Colors.white.withOpacity(0.2)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               m.text,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight:
//                       m.steps.isNotEmpty ? FontWeight.bold : FontWeight.normal),
//             ),
//             if (m.steps.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Divider(
//                   height: 1,
//                   color: Colors.white24),
//               const SizedBox(height: 10),
//               ...m.steps.map((step) => Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("• ",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white70,
//                                 fontWeight: FontWeight.bold)),
//                         Expanded(
//                           child: Text(step,
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white)),
//                         ),
//                       ],
//                     ),
//                   )),
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.2),
//           border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
//       child: Row(
//         children: [
//           // MIC BUTTON
//           GestureDetector(
//             onTap: _toggleListening,
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: _isListening ? Colors.red.withOpacity(0.8) : Theme.of(context).primaryColor.withOpacity(0.8),
//               child: Icon(_isListening ? Icons.stop : Icons.mic,
//                   color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 12),
//           // TEXT FIELD
//           Expanded(
//             child: TextField(
//               controller: _inputController,
//               enabled: true,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: _isListening ? "Listening..." : "How can I help?",
//                 hintStyle:
//                     const TextStyle(color: Colors.white54),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25),
//                     borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.1),
//               ),
//               onSubmitted: _sendMessage,
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             onPressed: () => _sendMessage(_inputController.text),
//             icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'package:line_icons/line_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// Assuming these paths match your project structure
import '../../providers/auth_provider.dart';
import '../../core/utils/localization_util.dart';

// --- Data Model ---
class ChatMessage {
  final String sender;
  final String text;
  final List<String> steps;

  ChatMessage({
    required this.sender,
    required this.text,
    this.steps = const [],
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final stt.SpeechToText _speech = stt.SpeechToText();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  bool _isListening = false;
  bool _isLoading = false;
  List<dynamic> _suggestions = [];

  late String _userId;
  late String _userName;
  late String _language;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthProvider>().user;
    _userId = authUser?.id ?? "guest";
    _userName = authUser?.fullName ?? "User";
    _language = authUser?.language ?? "English";

    _initSpeech();
    _initializeChat();
  }

  // FIXED: Added dispose method to prevent memory leaks
  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _initSpeech() async {
    try {
      await _speech.initialize(
        onError: (e) => debugPrint("Speech Error: $e"),
        onStatus: (status) => debugPrint("Speech Status: $status"),
      );
    } catch (e) {
      debugPrint("Speech init failed: $e");
    }
  }

  void _initializeChat() async {
    await _fetchSuggestions();
    await _fetchHistory();
  }

  // --- PARSING LOGIC ---
  ChatMessage _parseResponseData(Map<String, dynamic> data) {
    String mainText = data['aiSaid'] ?? data['response'] ?? data['translatedResponse'] ?? "";
    List<String> stepsList = [];

    if (data['steps'] != null && data['steps'] is List) {
      stepsList = List<String>.from(data['steps']);
    } else if (mainText.contains('[स्प्लिट]')) {
      List<String> parts = mainText.split('[स्प्लिट]');
      mainText = parts[0].trim();
      if (parts.length > 1) {
        stepsList = parts.sublist(1).map((s) => s.trim()).toList();
      }
    }

    return ChatMessage(sender: 'ai', text: mainText, steps: stepsList);
  }

  Future<void> _fetchSuggestions() async {
    try {
      final res = await _dio.get('tutorials', queryParameters: {
        'userId': _userId,
      });
      if (mounted) setState(() => _suggestions = res.data ?? []);
    } catch (e) {
      debugPrint("Suggestions Error: $e");
    }
  }

  Future<void> _fetchHistory() async {
    try {
      final res = await _dio.get('users/history/$_userId');
      if (res.data != null && res.data['history'] != null) {
        List history = res.data['history'];
        if (mounted) {
          setState(() {
            _messages.clear();
            for (var chat in history.reversed) {
              _messages.add(ChatMessage(sender: 'user', text: chat['originalText'] ?? ''));
              _messages.add(_parseResponseData(chat));
            }
          });
          _scrollToBottom();
        }
      } else {
        _addWelcomeMessage();
      }
    } catch (e) {
      if (mounted && _messages.isEmpty) _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(
            sender: 'ai',
            text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"));
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- Speech Logic ---
  void _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);

      if (_inputController.text.trim().isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        _sendMessage(_inputController.text);
      }
    } else {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);

        String localeId = "en_US";
        if (_language == "Hindi") localeId = "hi_IN";
        if (_language == "Malayalam") localeId = "ml_IN";
        if (_language == "Tamil") localeId = "ta_IN";

        _speech.listen(
          localeId: localeId,
          onResult: (val) {
            setState(() {
              _inputController.text = val.recognizedWords;
              _inputController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _inputController.text.length));
            });
          },
        );
      } else {
        _showError("Speech recognition denied or not available");
        if (await Permission.microphone.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    if (mounted) {
      setState(() {
        _messages.add(ChatMessage(sender: 'user', text: text));
        _isLoading = true;
        _inputController.clear();
      });
      _scrollToBottom();
    }

    try {
      final res = await _dio.post('users/voice-chat', data: {
        "userId": _userId,
        "textInput": text
      });

      if (mounted) {
        setState(() {
          _messages.add(_parseResponseData(res.data));
        });
        _scrollToBottom();
      }
    } catch (e) {
      _showError("Connection error. Check internet.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    }
  }

  void _clearHistory() async {
    try {
      await _dio.delete('users/history/$_userId');
      if (mounted) {
        setState(() {
          _messages.clear();
          _addWelcomeMessage();
        });
      }
    } catch (e) {
      _showError("Failed to clear history.");
    }
  }

  void _showError(String msg) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // FIXED: Added the missing `build` method wrapper
  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().user;
    
    // FIXED: Wrap state modifications in PostFrameCallback to prevent "setState during build" crashes
    if (authUser != null && authUser.language != _language) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _language = authUser.language ?? "English";
          });
          _initializeChat(); 
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent for GlassScaffold parent
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Digital Sarathi",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(
              "$_language ${LocalizationUtil.translate('nav_chat', _language)}",
              style: const TextStyle(fontSize: 12, color: Colors.white70)
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _clearHistory,
              icon: const Icon(LineIcons.trash, color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return _buildChatBubble(m);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Thinking...",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic)),
            ),
      
          // Suggestions
          if (!_isListening && _suggestions.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: _suggestions.length > 10 ? 10 : _suggestions.length,
                itemBuilder: (context, index) {
                  final title = _suggestions[index] is Map
                      ? _suggestions[index]['title']
                      : _suggestions[index].toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13)),
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withOpacity(0.2))),
                      onPressed: () => _sendMessage(title),
                    ),
                  );
                },
              ),
            ),
      
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage m) {
    bool isUser = m.sender == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor.withOpacity(0.4) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isUser
                ? const Radius.circular(18)
                : const Radius.circular(4),
            bottomRight: isUser
                ? const Radius.circular(4)
                : const Radius.circular(18),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: m.steps.isNotEmpty ? FontWeight.bold : FontWeight.normal),
            ),
            if (m.steps.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: Colors.white24),
              const SizedBox(height: 10),
              ...m.steps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(step,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
      child: Row(
        children: [
          // MIC BUTTON
          GestureDetector(
            onTap: _toggleListening,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: _isListening ? Colors.red.withOpacity(0.8) : Theme.of(context).primaryColor.withOpacity(0.8),
              child: Icon(_isListening ? Icons.stop : Icons.mic,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: _inputController,
              enabled: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _isListening ? "Listening..." : "How can I help?",
                hintStyle:
                    const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _sendMessage(_inputController.text),
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}