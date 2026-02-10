import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Storing the userId here as requested
  final String userId = "6958d283084e431c490edf8d";
  late Future<AssessmentReport> futureReport;

  @override
  void initState() {
    super.initState();
    futureReport = fetchAssessmentReport();
  }

  Future<AssessmentReport> fetchAssessmentReport() async {
    // Using the stored userId in the API URL
    final url = Uri.parse('https://sarathi-ai-8hk8.onrender.com/api/assessment/report/$userId');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return AssessmentReport.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load progress report');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Progress")),
      body: FutureBuilder<AssessmentReport>(
        future: futureReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Error: ${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Section
                  _buildStatusCard(data.status),
                  const SizedBox(height: 20),
                  
                  // Statistics Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          "Lessons Done", 
                          "${data.lessonsCompleted}", 
                          Icons.check_circle_outline,
                          Colors.blue
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          "Avg Score", 
                          data.averageQuizScore.toStringAsFixed(1), 
                          Icons.star_border,
                          Colors.orange
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Lesson List Header
                  Text(
                    "Completed Lessons", 
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 12),
                  
                  // List of Lessons
                  if (data.lessonTitles.isEmpty)
                    const Text("No lessons completed yet.")
                  else
                    ...data.lessonTitles.map((title) => Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.play_lesson, color: Colors.deepPurple),
                        title: Text(title),
                      ),
                    )),
                ],
              ),
            );
          }
          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  // Widget for the main Status display
  Widget _buildStatusCard(String status) {
    final isSuccess = status == "On Track";
    final color = isSuccess ? Colors.green : Colors.orange;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events, size: 60, color: color),
          const SizedBox(height: 12),
          Text(
            status,
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: color
            ),
          ),
          const Text("Overall Status", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget for small statistic cards
  Widget _buildInfoCard(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Data Model to parse the JSON response
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
      // Handle cases where score might be int or double in JSON
      averageQuizScore: (json['averageQuizScore'] ?? 0).toDouble(),
      status: json['status'] ?? 'Unknown',
    );
  }
}