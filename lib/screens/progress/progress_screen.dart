import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass_container.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late String userId;
  late Future<AssessmentReport> futureReport;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthProvider>().user;
    userId = authUser?.id ?? "guest";
    futureReport = fetchAssessmentReport();
  }

  Future<AssessmentReport> fetchAssessmentReport() async {
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
      backgroundColor: Colors.transparent, // Transparent because parent HomeScreen has GlassScaffold
      appBar: AppBar(
        title: const Text("My Progress", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<AssessmentReport>(
        future: futureReport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassContainer(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
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
                          Colors.lightBlueAccent
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          "Avg Score", 
                          data.averageQuizScore.toStringAsFixed(1), 
                          Icons.star_border,
                          Colors.amberAccent
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Lesson List Header
                  Text(
                    "Completed Lessons", 
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                  const SizedBox(height: 12),
                  
                  // List of Lessons
                  if (data.lessonTitles.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("No lessons completed yet.", style: TextStyle(color: Colors.white70)),
                    )
                  else
                    ...data.lessonTitles.map((title) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.play_lesson, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
                          ],
                        ),
                      ),
                    )),
                ],
              ),
            );
          }
          return const Center(child: Text("No data available", style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  // Widget for the main Status display
  Widget _buildStatusCard(String status) {
    final isSuccess = status == "On Track";
    final color = isSuccess ? Colors.greenAccent : Colors.orangeAccent;
    
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: Column(
        children: [
          Icon(Icons.emoji_events, size: 60, color: color),
          const SizedBox(height: 12),
          Text(
            status,
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: color,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: color.withOpacity(0.5),
                  offset: const Offset(0, 0),
                ),
              ]
            ),
          ),
          const Text("Overall Status", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // Widget for small statistic cards
  Widget _buildInfoCard(String label, String value, IconData icon, Color iconColor) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 32, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
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
      averageQuizScore: (json['averageQuizScore'] ?? 0).toDouble(),
      status: json['status'] ?? 'Unknown',
    );
  }
}