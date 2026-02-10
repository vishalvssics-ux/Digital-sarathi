// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:dio/dio.dart';
// // // import 'package:record/record.dart'; // Ensure record ^5.0.0 or higher
// // // import 'package:path_provider/path_provider.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:provider/provider.dart';
// // // import '../../providers/auth_provider.dart';

// // // // --- Data Model ---
// // // class ChatMessage {
// // //   final String sender; // 'user' or 'ai'
// // //   final String text;
// // //  // final List<dynamic>? steps;

// // //   ChatMessage({required this.sender, required this.text,s});
// // // }

// // // class ChatScreen extends StatefulWidget {
// // //   const ChatScreen({super.key});

// // //   @override
// // //   State<ChatScreen> createState() => _ChatScreenState();
// // // }

// // // class _ChatScreenState extends State<ChatScreen> {
// // //   final List<ChatMessage> _messages = [];
// // //   final TextEditingController _inputController = TextEditingController();
// // //   final ScrollController _scrollController = ScrollController();
// // //   final AudioRecorder _audioRecorder = AudioRecorder();
// // //   final Dio _dio = Dio(BaseOptions(baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/"));

// // //   bool _isRecording = false;
// // //   bool _isLoading = false;
// // //   List<dynamic> _suggestions = [];

// // //   // Mock User Data replaced with AuthProvider
// // //   late String _userId;
// // //   late String _userName;
// // //   final String _language = "English";

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     final authUser = context.read<AuthProvider>().user;
// // //     _userId = authUser?.id ?? "guest";
// // //     _userName = authUser?.fullName ?? "User";
    
// // //     _initializeChat();
// // //   }

// // //   void _initializeChat() async {
// // //     await _fetchSuggestions();
// // //     await _fetchHistory();
// // //   }

// // //   Future<void> _fetchSuggestions() async {
// // //     try {
// // //       final res = await _dio.get('tutorials');
// // //       if (mounted) {
// // //         setState(() => _suggestions = res.data ?? []);
// // //       }
// // //     } catch (e) {
// // //       debugPrint("Suggestions Error: $e");
// // //     }
// // //   }

// // //   Future<void> _fetchHistory() async {
// // //     try {
// // //       final res = await _dio.get('users/history/$_userId');
// // //       if (res.data != null && res.data['history'] != null) {
// // //         List history = res.data['history'];
// // //         if (mounted) {
// // //             setState(() {
// // //               _messages.clear();
// // //               for (var chat in history.reversed) {
// // //                 _messages.add(ChatMessage(sender: 'user', text: chat['originalText'] ?? ''));
// // //                 _messages.add(ChatMessage(sender: 'ai', text: chat['translatedResponse'] ?? ''));
// // //               }
// // //             });
// // //             _scrollToBottom();
// // //         }
// // //       } else {
// // //         if (mounted) {
// // //             setState(() {
// // //               _messages.add(ChatMessage(
// // //                 sender: 'ai', 
// // //                 text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"
// // //               ));
// // //             });
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint("History Error: $e");
// // //        if (mounted && _messages.isEmpty) {
// // //             setState(() {
// // //               _messages.add(ChatMessage(
// // //                 sender: 'ai', 
// // //                 text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"
// // //               ));
// // //             });
// // //         }
// // //     }
// // //   }

// // //   void _scrollToBottom() {
// // //     Future.delayed(const Duration(milliseconds: 300), () {
// // //       if (_scrollController.hasClients) {
// // //         _scrollController.animateTo(
// // //           _scrollController.position.maxScrollExtent,
// // //           duration: const Duration(milliseconds: 300),
// // //           curve: Curves.easeOut,
// // //         );
// // //       }
// // //     });
// // //   }

// // //   // --- Voice Logic ---
// // //   void _toggleRecording() async {
// // //     if (_isRecording) {
// // //       final path = await _audioRecorder.stop();
// // //       if (mounted) setState(() => _isRecording = false);
// // //       if (path != null) _sendVoiceToAI(path);
// // //     } else {
// // //       var status = await Permission.microphone.request();
// // //       if (status.isGranted) {
// // //         final directory = await getTemporaryDirectory();
// // //         final path = '${directory.path}/audio_query.wav';
// // //         // Ensure parent directory exists?
// // //         // Start recording
// // //         if (await _audioRecorder.hasPermission()) {
// // //              await _audioRecorder.start(const RecordConfig(), path: path);
// // //              if (mounted) setState(() => _isRecording = true);
// // //         }
// // //       }
// // //     }
// // //   }

// // //   Future<void> _sendVoiceToAI(String path) async {
// // //     if(mounted) setState(() => _isLoading = true);
// // //     try {
// // //       final file = File(path);
// // //       if(!file.existsSync()) {
// // //           debugPrint("File not found: $path");
// // //           return;
// // //       }
// // //       final bytes = await file.readAsBytes();
// // //       String base64Audio = "data:audio/wav;base64,${base64Encode(bytes)}";

// // //       final res = await _dio.post('users/voice-chat', data: {
// // //         "userId": _userId,
// // //         "audioBase64": base64Audio
// // //       });

// // //     if (res.data != null) {
// // //       // Check for success flag if exists, otherwise assume success if data present
// // //        // The user's code checks res.data['success'], so likely API returns { success: true, ... }
// // //         if (res.data['success'] == true || res.data['userSaid'] != null) {
// // //             if (mounted) {
// // //                 setState(() {
// // //                   _messages.add(ChatMessage(sender: 'user', text: res.data['userSaid'] ?? "Audio Input"));
// // //                   _messages.add(ChatMessage(
// // //                     sender: 'ai', 
// // //                     text: res.data['aiSaid'] ?? "I heard you.", 
// // //                     // steps: res.data['steps']
// // //                   ));
// // //                 });
// // //                 _scrollToBottom();
// // //             }
// // //         }
// // //       }
// // //     } catch (e) {
// // //       _showError("Voice processing failed: $e");
// // //     } finally {
// // //       if(mounted) setState(() => _isLoading = false);
// // //     }
// // //   }

// // //   // --- Text Logic ---
// // //   Future<void> _sendMessage(String text) async {
// // //     if (text.trim().isEmpty) return;
    
// // //     if(mounted) {
// // //         setState(() {
// // //           _messages.add(ChatMessage(sender: 'user', text: text));
// // //           _isLoading = true;
// // //         });
// // //     }
// // //     _inputController.clear();
// // //     _scrollToBottom();

// // //     try {
// // //       final res = await _dio.post('users/voice-chat', data: {
// // //         "userId": _userId,
// // //         "textInput": text
// // //       });

// // //       if (mounted) {
// // //         // Handle response
// // //         // User code expects: aiSaid, steps
// // //          setState(() {
// // //             _messages.add(ChatMessage(
// // //               sender: 'ai', 
// // //               text: res.data['aiSaid'] ?? res.data['response'] ?? "Here is what I found.", 
// // //            //   steps: res.data['steps']
// // //             ));
// // //           });
// // //           _scrollToBottom();
// // //       }
// // //     } catch (e) {
// // //       _showError("Connection error.");
// // //     } finally {
// // //       if(mounted) setState(() => _isLoading = false);
// // //     }
// // //   }

// // //   void _clearHistory() async {
// // //     bool? confirm = await showDialog(
// // //       context: context,
// // //       builder: (c) => AlertDialog(
// // //         title: const Text("Clear History?"),
// // //         content: const Text("Do you want to delete all chat history?"),
// // //         actions: [
// // //           TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancel")),
// // //           TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Clear", style: TextStyle(color: Colors.red))),
// // //         ],
// // //       )
// // //     );

// // //     if (confirm == true) {
// // //       try {
// // //         await _dio.delete('users/history/$_userId');
// // //         if (mounted) {
// // //             setState(() {
// // //               _messages.clear();
// // //               _messages.add(ChatMessage(sender: 'ai', text: "History cleared. How can I help you?"));
// // //             });
// // //         }
// // //       } catch (e) {
// // //         _showError("Failed to clear history.");
// // //       }
// // //     }
// // //   }

// // //   void _showError(String msg) {
// // //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF8F9FA),
// // //       appBar: AppBar(
// // //         backgroundColor: const Color(0xFF1A73E8),
// // //         title: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             const Text("Digital Sarathi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
// // //             Text("$_language Mode", style: const TextStyle(fontSize: 12, color: Colors.white70)),
// // //           ],
// // //         ),
// // //         actions: [
// // //           IconButton(onPressed: _clearHistory, icon: const Icon(Icons.delete_outline, color: Colors.white)),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // Chat window
// // //           Expanded(
// // //             child: ListView.builder(
// // //               controller: _scrollController,
// // //               padding: const EdgeInsets.all(16),
// // //               itemCount: _messages.length,
// // //               itemBuilder: (context, index) {
// // //                 final m = _messages[index];
// // //                 return _buildChatBubble(m);
// // //               },
// // //             ),
// // //           ),

// // //           if (_isLoading)
// // //             const Padding(
// // //               padding: EdgeInsets.all(8.0),
// // //               child: Text("Thinking...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
// // //             ),

// // //           // Suggestions
// // //           if (!_isRecording && _suggestions.isNotEmpty)
// // //             SizedBox(
// // //               height: 50,
// // //               child: ListView.builder(
// // //                 scrollDirection: Axis.horizontal,
// // //                 padding: const EdgeInsets.symmetric(horizontal: 10),
// // //                 itemCount: _suggestions.length > 10 ? 10 : _suggestions.length,
// // //                 itemBuilder: (context, index) {
// // //                   // Assuming suggestions is list of maps with title
// // //                   // If suggestions is raw strings, handle that
// // //                   final title = _suggestions[index] is Map ? _suggestions[index]['title'] : _suggestions[index].toString();
// // //                   return Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 4),
// // //                     child: ActionChip(
// // //                       label: Text(title, style: const TextStyle(color: Color(0xFF1A73E8), fontSize: 13)),
// // //                       backgroundColor: Colors.white,
// // //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF1A73E8))),
// // //                       onPressed: () => _sendMessage(title),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //             ),

// // //           // Input Area
// // //           _buildInputArea(),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildChatBubble(ChatMessage m) {
// // //     bool isUser = m.sender == 'user';
// // //     return Align(
// // //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// // //       child: Container(
// // //         margin: const EdgeInsets.symmetric(vertical: 8),
// // //         padding: const EdgeInsets.all(14),
// // //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
// // //         decoration: BoxDecoration(
// // //           color: isUser ? const Color(0xFF1A73E8) : Colors.white,
// // //           borderRadius: BorderRadius.only(
// // //             topLeft: const Radius.circular(18),
// // //             topRight: const Radius.circular(18),
// // //             bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
// // //             bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
// // //           ),
// // //           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
// // //           border: isUser ? null : Border.all(color: const Color(0xFFEEEEEE)),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               m.text,
// // //               style: TextStyle(color: isUser ? Colors.white : const Color(0xFF3C4043), fontWeight: m.text != null ? FontWeight.bold : FontWeight.normal),
// // //             ),
// // //             if (m.text != null && m.text!.isNotEmpty) ...[
// // //               const Divider(height: 20, color: Colors.grey),
// // //               ...m.text.map((step) => Padding(
// // //                 padding: const EdgeInsets.only(bottom: 6),
// // //                 child: Text("• ${step is Map ? step['instruction'] : step}", style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
// // //               )),
// // //             ]
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInputArea() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
// // //       child: Row(
// // //         children: [
// // //           GestureDetector(
// // //             onTap: _toggleRecording,
// // //             child: CircleAvatar(
// // //               radius: 25,
// // //               backgroundColor: _isRecording ? Colors.red : const Color(0xFF1A73E8),
// // //               child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
// // //             ),
// // //           ),
// // //           const SizedBox(width: 12),
// // //           Expanded(
// // //             child: TextField(
// // //               controller: _inputController,
// // //               enabled: !_isRecording,
// // //               decoration: InputDecoration(
// // //                 hintText: _isRecording ? "Listening..." : "How can I help?",
// // //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
// // //                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// // //                 filled: true,
// // //                 fillColor: const Color(0xFFF8F9FA),
// // //               ),
// // //               onSubmitted: _sendMessage,
// // //             ),
// // //           ),
// // //           const SizedBox(width: 8),
// // //           IconButton(
// // //             onPressed: () => _sendMessage(_inputController.text),
// // //             icon: const Icon(Icons.send, color: Color(0xFF1A73E8)),
// // //           )
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import 'package:record/record.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:provider/provider.dart';
// // import '../../providers/auth_provider.dart';

// // // --- 1. Updated Data Model ---
// // class ChatMessage {
// //   final String sender; // 'user' or 'ai'
// //   final String text;   // Main response text
// //   final List<String> steps; // List of steps extracted from the response

// //   ChatMessage({
// //     required this.sender, 
// //     required this.text, 
// //     this.steps = const [], // Default to empty list
// //   });
// // }

// // class ChatScreen extends StatefulWidget {
// //   const ChatScreen({super.key});

// //   @override
// //   State<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> {
// //   final List<ChatMessage> _messages = [];
// //   final TextEditingController _inputController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //   final AudioRecorder _audioRecorder = AudioRecorder();
// //   final Dio _dio = Dio(BaseOptions(baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/"));

// //   bool _isRecording = false;
// //   bool _isLoading = false;
// //   List<dynamic> _suggestions = [];

// //   late String _userId;
// //   late String _userName;
// //   final String _language = "English";

// //   @override
// //   void initState() {
// //     super.initState();
// //     final authUser = context.read<AuthProvider>().user;
// //     _userId = authUser?.id ?? "guest";
// //     _userName = authUser?.fullName ?? "User";
    
// //     _initializeChat();
// //   }

// //   void _initializeChat() async {
// //     await _fetchSuggestions();
// //     await _fetchHistory();
// //   }

// //   // --- 2. Helper to Parse the Split String ---
// //   ChatMessage _parseAIResponse(String aiSaid) {
// //     // Split the string by the specific delimiter provided in your JSON
// //     // Note: ensure the brackets and characters match exactly what the API sends
// //     List<String> parts = aiSaid.split('[स्प्लिट]'); 

// //     String mainText = parts.isNotEmpty ? parts[0].trim() : "";
// //     List<String> stepsList = [];

// //     if (parts.length > 1) {
// //       // All parts after the first one are steps
// //       stepsList = parts.sublist(1).map((s) => s.trim()).toList();
// //     }

// //     return ChatMessage(
// //       sender: 'ai',
// //       text: mainText,
// //       steps: stepsList,
// //     );
// //   }

// //   Future<void> _fetchSuggestions() async {
// //     try {
// //       final res = await _dio.get('tutorials');
// //       if (mounted) {
// //         setState(() => _suggestions = res.data ?? []);
// //       }
// //     } catch (e) {
// //       debugPrint("Suggestions Error: $e");
// //     }
// //   }

// //   Future<void> _fetchHistory() async {
// //     try {
// //       final res = await _dio.get('users/history/$_userId');
// //       if (res.data != null && res.data['history'] != null) {
// //         List history = res.data['history'];
// //         if (mounted) {
// //             setState(() {
// //               _messages.clear();
// //               for (var chat in history.reversed) {
// //                 // Add User Message
// //                 _messages.add(ChatMessage(sender: 'user', text: chat['originalText'] ?? ''));
                
// //                 // Add AI Message (Parse it using the helper in case history has the same format)
// //                 String aiResponse = chat['translatedResponse'] ?? '';
// //                 _messages.add(_parseAIResponse(aiResponse));
// //               }
// //             });
// //             _scrollToBottom();
// //         }
// //       } else {
// //         _addWelcomeMessage();
// //       }
// //     } catch (e) {
// //       debugPrint("History Error: $e");
// //       if (mounted && _messages.isEmpty) _addWelcomeMessage();
// //     }
// //   }

// //   void _addWelcomeMessage() {
// //     if (mounted) {
// //       setState(() {
// //         _messages.add(ChatMessage(
// //           sender: 'ai', 
// //           text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"
// //         ));
// //       });
// //     }
// //   }

// //   void _scrollToBottom() {
// //     Future.delayed(const Duration(milliseconds: 300), () {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }

// //   // --- Voice Logic ---
// //   void _toggleRecording() async {
// //     if (_isRecording) {
// //       final path = await _audioRecorder.stop();
// //       if (mounted) setState(() => _isRecording = false);
// //       if (path != null) _sendVoiceToAI(path);
// //     } else {
// //       var status = await Permission.microphone.request();
// //       if (status.isGranted) {
// //         final directory = await getTemporaryDirectory();
// //         final path = '${directory.path}/audio_query.wav';
// //         if (await _audioRecorder.hasPermission()) {
// //              await _audioRecorder.start(const RecordConfig(), path: path);
// //              if (mounted) setState(() => _isRecording = true);
// //         }
// //       }
// //     }
// //   }

// //   Future<void> _sendVoiceToAI(String path) async {
// //     if(mounted) setState(() => _isLoading = true);
// //     try {
// //       final file = File(path);
// //       if(!file.existsSync()) return;
      
// //       final bytes = await file.readAsBytes();
// //       String base64Audio = "data:audio/wav;base64,${base64Encode(bytes)}";

// //       final res = await _dio.post('users/voice-chat', data: {
// //         "userId": _userId,
// //         "audioBase64": base64Audio
// //       });

// //       if (res.data != null) {
// //         if (res.data['success'] == true || res.data['userSaid'] != null) {
// //             if (mounted) {
// //                 setState(() {
// //                   // 1. Add User Input
// //                   _messages.add(ChatMessage(sender: 'user', text: res.data['userSaid'] ?? "Audio Input"));
                  
// //                   // 2. Parse and Add AI Response
// //                   String rawAiResponse = res.data['aiSaid'] ?? "I heard you.";
// //                   _messages.add(_parseAIResponse(rawAiResponse));
// //                 });
// //                 _scrollToBottom();
// //             }
// //         }
// //       }
// //     } catch (e) {
// //       _showError("Voice processing failed: $e");
// //     } finally {
// //       if(mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   // --- Text Logic ---
// //   Future<void> _sendMessage(String text) async {
// //     if (text.trim().isEmpty) return;
    
// //     if(mounted) {
// //         setState(() {
// //           _messages.add(ChatMessage(sender: 'user', text: text));
// //           _isLoading = true;
// //         });
// //     }
// //     _inputController.clear();
// //     _scrollToBottom();

// //     try {
// //       final res = await _dio.post('users/voice-chat', data: {
// //         "userId": _userId,
// //         "textInput": text
// //       });
// //       print(res.data);

// //       if (mounted) {
// //          setState(() {
// //             // Parse and Add AI Response
// //             String rawAiResponse = res.data['aiSaid'] ?? res.data['response'] ?? "Here is what I found.";
// //             _messages.add(_parseAIResponse(rawAiResponse));
// //           });
// //           _scrollToBottom();
// //       }
// //     } catch (e) {
// //       _showError("Connection error.");
// //     } finally {
// //       if(mounted) setState(() => _isLoading = false);
// //     }
// //   }

// //   void _clearHistory() async {
// //     // ... existing clear history logic ...
// //     // (Kept same as your code, just omitted for brevity)
// //   }

// //   void _showError(String msg) {
// //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8F9FA),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF1A73E8),
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text("Digital Sarathi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
// //             Text("$_language Mode", style: const TextStyle(fontSize: 12, color: Colors.white70)),
// //           ],
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               padding: const EdgeInsets.all(16),
// //               itemCount: _messages.length,
// //               itemBuilder: (context, index) {
// //                 final m = _messages[index];
// //                 return _buildChatBubble(m);
// //               },
// //             ),
// //           ),
// //           if (_isLoading)
// //             const Padding(
// //               padding: EdgeInsets.all(8.0),
// //               child: Text("Thinking...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
// //             ),
// //           // ... Suggestions Widget (Same as your code) ...
// //           _buildInputArea(),
// //         ],
// //       ),
// //     );
// //   }

// //   // --- 3. Fixed Chat Bubble UI ---
// //   Widget _buildChatBubble(ChatMessage m) {
// //     bool isUser = m.sender == 'user';
    
// //     return Align(
// //       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(vertical: 8),
// //         padding: const EdgeInsets.all(14),
// //         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
// //         decoration: BoxDecoration(
// //           color: isUser ? const Color(0xFF1A73E8) : Colors.white,
// //           borderRadius: BorderRadius.only(
// //             topLeft: const Radius.circular(18),
// //             topRight: const Radius.circular(18),
// //             bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
// //             bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
// //           ),
// //           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
// //           border: isUser ? null : Border.all(color: const Color(0xFFEEEEEE)),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Main Text / Header
// //             Text(
// //               m.text,
// //               style: TextStyle(
// //                 color: isUser ? Colors.white : const Color(0xFF3C4043),
// //                 fontSize: 16,
// //                 fontWeight: m.steps.isNotEmpty ? FontWeight.bold : FontWeight.normal
// //               ),
// //             ),

// //             // Steps List (Only renders if steps exist)
// //             if (m.steps.isNotEmpty) ...[
// //               const SizedBox(height: 10),
// //               Divider(height: 1, color: isUser ? Colors.white24 : Colors.grey.shade300),
// //               const SizedBox(height: 10),
// //               ...m.steps.map((step) => Padding(
// //                 padding: const EdgeInsets.only(bottom: 8),
// //                 child: Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // Bullet Point
// //                     Text("• ", style: TextStyle(
// //                       fontSize: 16, 
// //                       color: isUser ? Colors.white70 : const Color(0xFF1A73E8),
// //                       fontWeight: FontWeight.bold
// //                     )),
// //                     // Step Text
// //                     Expanded(
// //                       child: Text(
// //                         step, 
// //                         style: TextStyle(
// //                           fontSize: 14, 
// //                           color: isUser ? Colors.white : const Color(0xFF555555)
// //                         )
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               )),
// //             ]
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInputArea() {
// //      // ... Your existing input area code ...
// //      // Included here for completeness of context
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
// //       child: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: _toggleRecording,
// //             child: CircleAvatar(
// //               radius: 25,
// //               backgroundColor: _isRecording ? Colors.red : const Color(0xFF1A73E8),
// //               child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: TextField(
// //               controller: _inputController,
// //               enabled: !_isRecording,
// //               decoration: InputDecoration(
// //                 hintText: _isRecording ? "Listening..." : "How can I help?",
// //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
// //                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                 filled: true,
// //                 fillColor: const Color(0xFFF8F9FA),
// //               ),
// //               onSubmitted: _sendMessage,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           IconButton(
// //             onPressed: () => _sendMessage(_inputController.text),
// //             icon: const Icon(Icons.send, color: Color(0xFF1A73E8)),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';

// // --- Data Model ---
// class ChatMessage {
//   final String sender; // 'user' or 'ai'
//   final String text;   // Main response text
//   final List<String> steps; // List of steps

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
//   final AudioRecorder _audioRecorder = AudioRecorder();
//   final Dio _dio = Dio(BaseOptions(baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/"));

//   bool _isRecording = false;
//   bool _isLoading = false;
//   List<dynamic> _suggestions = [];

//   late String _userId;
//   late String _userName;
//   final String _language = "English";

//   @override
//   void initState() {
//     super.initState();
//     final authUser = context.read<AuthProvider>().user;
//     _userId = authUser?.id ?? "guest";
//     _userName = authUser?.fullName ?? "User";
    
//     _initializeChat();
//   }

//   void _initializeChat() async {
//     await _fetchSuggestions();
//     await _fetchHistory();
//   }

//   // --- NEW PARSING LOGIC ---
//   // This handles both the explicit 'steps' list AND the '[स्प्लिट]' string format
//   ChatMessage _parseResponseData(Map<String, dynamic> data) {
//     String mainText = data['aiSaid'] ?? data['response'] ?? data['translatedResponse'] ?? "";
//     List<String> stepsList = [];

//     // 1. Priority: Check if explicit 'steps' list exists in JSON
//     if (data['steps'] != null && data['steps'] is List) {
//       stepsList = List<String>.from(data['steps']);
//     }
    
//     // 2. Fallback: If no explicit list, check if text contains split delimiter
//     // (This keeps it working if the API reverts to the old format)
//     else if (mainText.contains('[स्प्लिट]')) {
//       List<String> parts = mainText.split('[स्प्लिट]');
//       mainText = parts[0].trim(); // Update mainText to remove steps
//       if (parts.length > 1) {
//         stepsList = parts.sublist(1).map((s) => s.trim()).toList();
//       }
//     }

//     return ChatMessage(
//       sender: 'ai',
//       text: mainText,
//       steps: stepsList,
//     );
//   }

//   Future<void> _fetchSuggestions() async {
//     try {
//       final res = await _dio.get('tutorials');
//       if (mounted) {
//         setState(() => _suggestions = res.data ?? []);
//       }
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
//             setState(() {
//               _messages.clear();
//               for (var chat in history.reversed) {
//                 _messages.add(ChatMessage(sender: 'user', text: chat['originalText'] ?? ''));
                
//                 // Pass the whole chat object to the parser to find steps
//                 _messages.add(_parseResponseData(chat));
//               }
//             });
//             _scrollToBottom();
//         }
//       } else {
//         _addWelcomeMessage();
//       }
//     } catch (e) {
//       debugPrint("History Error: $e");
//       if (mounted && _messages.isEmpty) _addWelcomeMessage();
//     }
//   }

//   void _addWelcomeMessage() {
//     if (mounted) {
//       setState(() {
//         _messages.add(ChatMessage(
//           sender: 'ai', 
//           text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"
//         ));
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
//   // --- Voice Logic ---
//   void _toggleRecording() async {
//     try {
//       if (_isRecording) {
//         // 1. Stop Recording
//         final path = await _audioRecorder.stop();
        
//         if (mounted) setState(() => _isRecording = false);

//         // 2. Validate path and send
//         if (path != null) {
//           _sendVoiceToAI(path);
//         }
//       } else {
//         // 3. Permissions & Start
//         if (await _audioRecorder.hasPermission()) {
//           final directory = await getTemporaryDirectory();
//           final path = '${directory.path}/audio_query.wav';

//           // 4. CRITICAL FIX: Force WAV encoding and 16k sample rate
//           // AI models perform best with 16kHz Mono WAV files.
//           const config = RecordConfig(
//             encoder: AudioEncoder.wav, 
//             sampleRate: 16000, 
//             numChannels: 1,
//           );

//           // 5. Start recording
//           await _audioRecorder.start(config, path: path);
          
//           if (mounted) setState(() => _isRecording = true);
//         }
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isRecording = false);
//       _showError("Microphone error: $e");
//     }
//   }

//   Future<void> _sendVoiceToAI(String path) async {
//     if (mounted) setState(() => _isLoading = true);
    
//     try {
//       final file = File(path);
//       if (!await file.exists()) {
//         _showError("Audio file creation failed.");
//         return;
//       }
      
//       final bytes = await file.readAsBytes();
      
//       // --- BASE64 FORMAT CHECK ---
//       // Most APIs expect JUST the base64 string. 
//       // Only keep "data:audio/wav;base64," if your specific API documentation demands it.
//       // If your API fails, try removing the prefix string below.
//       String base64Audio = "data:audio/wav;base64,${base64Encode(bytes)}"; 

//       // Optional: Log size to debug
//       debugPrint("Sending Audio: ${bytes.lengthInBytes} bytes");

//       final res = await _dio.post(
//         'users/voice-chat', 
//         data: {
//           "userId": _userId,
//           "audioBase64": base64Audio
//         },
//         // Increase timeout for audio uploads (slow connections)
//         options: Options(sendTimeout: const Duration(seconds: 20)), 
//       );

//       if (res.data != null && mounted) {
//         // Check for success flag or existence of userSaid
//         if (res.data['success'] == true || res.data['userSaid'] != null) {
//            setState(() {
//               // 1. Show what the AI heard (User bubble)
//               _messages.add(ChatMessage(
//                 sender: 'user', 
//                 text: res.data['userSaid'] ?? "Audio Input"
//               ));
              
//               // 2. Show AI response (AI bubble)
//               _messages.add(_parseResponseData(res.data));
//            });
//            _scrollToBottom();
//         } else {
//            _showError(res.data['message'] ?? "AI could not understand audio.");
//         }
//       }
//     } catch (e) {
//       debugPrint("Voice Upload Error: $e"); // Helpful for debugging
//       _showError("Voice connection failed. Please try again.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // // --- Voice Logic ---
//   // void _toggleRecording() async {
//   //   if (_isRecording) {
//   //     final path = await _audioRecorder.stop();
//   //     if (mounted) setState(() => _isRecording = false);
//   //     if (path != null) _sendVoiceToAI(path);
//   //   } else {
//   //     var status = await Permission.microphone.request();
//   //     if (status.isGranted) {
//   //       final directory = await getTemporaryDirectory();
//   //       final path = '${directory.path}/audio_query.wav';
//   //       if (await _audioRecorder.hasPermission()) {
//   //            await _audioRecorder.start(const RecordConfig(), path: path);
//   //            if (mounted) setState(() => _isRecording = true);
//   //       }
//   //     }
//   //   }
//   // }

//   // Future<void> _sendVoiceToAI(String path) async {
//   //   if(mounted) setState(() => _isLoading = true);
//   //   try {
//   //     final file = File(path);
//   //     if(!file.existsSync()) return;
      
//   //     final bytes = await file.readAsBytes();
//   //     String base64Audio = "data:audio/wav;base64,${base64Encode(bytes)}";

//   //     final res = await _dio.post('users/voice-chat', data: {
//   //       "userId": _userId,
//   //       "audioBase64": base64Audio
//   //     });

//   //     if (res.data != null) {
//   //       if (res.data['success'] == true || res.data['userSaid'] != null) {
//   //           if (mounted) {
//   //               setState(() {
//   //                 _messages.add(ChatMessage(sender: 'user', text: res.data['userSaid'] ?? "Audio Input"));
                  
//   //                 // Use new parser with the full Map
//   //                 _messages.add(_parseResponseData(res.data));
//   //               });
//   //               _scrollToBottom();
//   //           }
//   //       }
//   //     }
//   //   } catch (e) {
//   //     _showError("Voice processing failed: $e");
//   //   } finally {
//   //     if(mounted) setState(() => _isLoading = false);
//   //   }
//   // }

//   // --- Text Logic ---
//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
    
//     if(mounted) {
//         setState(() {
//           _messages.add(ChatMessage(sender: 'user', text: text));
//           _isLoading = true;
//         });
//     }
//     _inputController.clear();
//     _scrollToBottom();

//     try {
//       final res = await _dio.post('users/voice-chat', data: {
//         "userId": _userId,
//         "textInput": text
//       });

//       if (mounted) {
//          setState(() {
//             // Use new parser with the full Map
//             _messages.add(_parseResponseData(res.data));
//           });
//           _scrollToBottom();
//       }
//     } catch (e) {
//       _showError("Connection error.");
//     } finally {
//       if(mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _clearHistory() async {
//     // ... (Existing clear logic) ...
//     // Placeholder to keep code short
//     try {
//         await _dio.delete('users/history/$_userId');
//         if (mounted) {
//             setState(() {
//               _messages.clear();
//               _addWelcomeMessage();
//             });
//         }
//       } catch (e) {
//         _showError("Failed to clear history.");
//       }
//   }

//   void _showError(String msg) {
//     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1A73E8),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Digital Sarathi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//             Text("$_language Mode", style: const TextStyle(fontSize: 12, color: Colors.white70)),
//           ],
//         ),
//         actions: [
//           IconButton(onPressed: _clearHistory, icon: const Icon(Icons.delete_outline, color: Colors.white)),
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
//               child: Text("Thinking...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
//             ),
          
//            // Suggestions
//           if (!_isRecording && _suggestions.isNotEmpty)
//             SizedBox(
//               height: 50,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 itemCount: _suggestions.length > 10 ? 10 : _suggestions.length,
//                 itemBuilder: (context, index) {
//                   final title = _suggestions[index] is Map ? _suggestions[index]['title'] : _suggestions[index].toString();
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: ActionChip(
//                       label: Text(title, style: const TextStyle(color: Color(0xFF1A73E8), fontSize: 13)),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF1A73E8))),
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
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
//         decoration: BoxDecoration(
//           color: isUser ? const Color(0xFF1A73E8) : Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
//             bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
//           ),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
//           border: isUser ? null : Border.all(color: const Color(0xFFEEEEEE)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               m.text,
//               style: TextStyle(
//                 color: isUser ? Colors.white : const Color(0xFF3C4043),
//                 fontSize: 16,
//                 fontWeight: m.steps.isNotEmpty ? FontWeight.bold : FontWeight.normal
//               ),
//             ),
//             if (m.steps.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Divider(height: 1, color: isUser ? Colors.white24 : Colors.grey.shade300),
//               const SizedBox(height: 10),
//               // Loop through the steps list and display them
//               ...m.steps.map((step) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("• ", style: TextStyle(
//                       fontSize: 16, 
//                       color: isUser ? Colors.white70 : const Color(0xFF1A73E8),
//                       fontWeight: FontWeight.bold
//                     )),
//                     Expanded(
//                       child: Text(
//                         step, 
//                         style: TextStyle(
//                           fontSize: 14, 
//                           color: isUser ? Colors.white : const Color(0xFF555555)
//                         )
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: _toggleRecording,
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: _isRecording ? Colors.red : const Color(0xFF1A73E8),
//               child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: _inputController,
//               enabled: !_isRecording,
//               decoration: InputDecoration(
//                 hintText: _isRecording ? "Listening..." : "How can I help?",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 filled: true,
//                 fillColor: const Color(0xFFF8F9FA),
//               ),
//               onSubmitted: _sendMessage,
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             onPressed: () => _sendMessage(_inputController.text),
//             icon: const Icon(Icons.send, color: Color(0xFF1A73E8)),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // NEW PACKAGE
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

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
  
  // REPLACED AudioRecorder with SpeechToText
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://sarathi-ai-8hk8.onrender.com/api/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  bool _isListening = false; // Changed from _isRecording
  bool _isLoading = false;
  List<dynamic> _suggestions = [];

  late String _userId;
  late String _userName;
  final String _language = "English"; // Change this dynamically if needed

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthProvider>().user;
    _userId = authUser?.id ?? "guest";
    _userName = authUser?.fullName ?? "User";
    
    _initSpeech();
    _initializeChat();
  }

  // Initialize Speech Engine
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
      final res = await _dio.get('tutorials');
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
          text: "Namaskaram $_userName! I am Digital Sarathi. How can I guide you today?"
        ));
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

  // --- NEW: Real-time Speech to Text Logic ---
  void _toggleListening() async {
    // 1. If currently listening, STOP and SEND
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      
      // Auto-send if text exists
      if (_inputController.text.trim().isNotEmpty) {
        // Small delay to let final partial results settle
        await Future.delayed(const Duration(milliseconds: 500));
        _sendMessage(_inputController.text);
      }
    } 
    // 2. If not listening, START
    else {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        
        // Map your app's language to Locale ID
        // Malayalam: ml_IN, Hindi: hi_IN, Tamil: ta_IN, English: en_US
        String localeId = "en_US"; 
        if (_language == "Hindi") localeId = "hi_IN";
        if (_language == "Malayalam") localeId = "ml_IN";
        if (_language == "Tamil") localeId = "ta_IN";

        _speech.listen(
          localeId: localeId,
          onResult: (val) {
            setState(() {
              // Updates input box instantly as you speak
              _inputController.text = val.recognizedWords;
              
              // Keep cursor at the end
              _inputController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _inputController.text.length));
            });
          },
        );
      } else {
        _showError("Speech recognition denied or not available");
        // Fallback: Open settings if permission permanently denied
        if (await Permission.microphone.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }
  }

  // --- Text Logic (Used for both Typing AND Speech results) ---
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Stop listening if sending manually
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    if(mounted) {
        setState(() {
          _messages.add(ChatMessage(sender: 'user', text: text));
          _isLoading = true;
          _inputController.clear(); // Clear box after sending
        });
        _scrollToBottom();
    }

    try {
      // NOTE: We send 'textInput' now, not 'audioBase64'
      // This is much faster and avoids the audio encoding errors
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
      if(mounted) setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Digital Sarathi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("$_language Mode", style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(onPressed: _clearHistory, icon: const Icon(Icons.delete_outline, color: Colors.white)),
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
              child: Text("Thinking...", style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
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
                  final title = _suggestions[index] is Map ? _suggestions[index]['title'] : _suggestions[index].toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      label: Text(title, style: const TextStyle(color: Color(0xFF1A73E8), fontSize: 13)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF1A73E8))),
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
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF1A73E8) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
          border: isUser ? null : Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m.text,
              style: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF3C4043),
                fontSize: 16,
                fontWeight: m.steps.isNotEmpty ? FontWeight.bold : FontWeight.normal
              ),
            ),
            if (m.steps.isNotEmpty) ...[
              const SizedBox(height: 10),
              Divider(height: 1, color: isUser ? Colors.white24 : Colors.grey.shade300),
              const SizedBox(height: 10),
              ...m.steps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ", style: TextStyle(
                      fontSize: 16, 
                      color: isUser ? Colors.white70 : const Color(0xFF1A73E8),
                      fontWeight: FontWeight.bold
                    )),
                    Expanded(
                      child: Text(step, style: TextStyle(fontSize: 14, color: isUser ? Colors.white : const Color(0xFF555555))),
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
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(
        children: [
          // MIC BUTTON
          GestureDetector(
            onTap: _toggleListening,
            child: CircleAvatar(
              radius: 25,
              // Visual feedback for recording
              backgroundColor: _isListening ? Colors.red : const Color(0xFF1A73E8),
              child: Icon(_isListening ? Icons.stop : Icons.mic, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: _inputController,
              // We keep this enabled even while listening so users see text appear
              enabled: true, 
              decoration: InputDecoration(
                hintText: _isListening ? "Listening..." : "How can I help?",
                hintStyle: TextStyle(color: _isListening ? Colors.red : Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFFDDDDDD))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _sendMessage(_inputController.text),
            icon: const Icon(Icons.send, color: Color(0xFF1A73E8)),
          )
        ],
      ),
    );
  }
}