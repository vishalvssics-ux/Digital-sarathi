class ChatMessage {
  final String role; // "user" or "model" or "assistant"
  final String content;
  final DateTime? timestamp;
  final List? steps;

  ChatMessage({
    required this.role,
    required this.content,
    this.timestamp, 
    this.steps
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      steps: json['steps'] != null ? List<String>.from(json['steps']) : [],
      timestamp: DateTime.now(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
  
  bool get isUser => role == 'user';
}
