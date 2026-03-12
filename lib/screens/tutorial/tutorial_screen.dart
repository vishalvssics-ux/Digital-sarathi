import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late YoutubePlayerController _controller;
  
  // Add a boolean to track if the player has finished initializing
  bool _isPlayerReady = false;

  final List<Map<String, String>> _tutorialList = [
    {
      'title': 'Send a Voice Message in WhatsApp',
      'videoId': 'https://youtube.com/shorts/hMoA6Z06NII?si=b71YXVXDm9DDGqNe', 
    },
    {
      'title': 'Upload Documents in DigiLocker',
      'videoId': '1ukSR1GRtMU', 
    },
    {
      'title': 'Send Location in WhatsApp',
      'videoId': 'fq4N0hgOWzU', 
    },
    {
      'title': 'Take Pro Photo on Smartphone',
      'videoId': 'pTJJsmejUOQ', 
    },
    {
      'title': 'Delete YouTube History',
      'videoId': 'x0nAJAJjPNA', 
    },
    {
      'title': 'Download app in playstore',
      'videoId': 'Dk-eFp3O-yE', 
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _tutorialList[0]['videoId']!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(_listener); // Add a listener to monitor state
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // FIX: Only pause if the controller is completely ready
    if (_controller.value.isReady) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // The YouTube Player widget
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            // FIX: Tell the app when the player is completely ready
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
            },
            progressColors: const ProgressBarColors(
              playedColor: Colors.blueAccent,
              handleColor: Colors.blueAccent,
            ),
            bottomActions: [
               CurrentPosition(),
               ProgressBar(isExpanded: true),
               RemainingDuration(),
               PlaybackSpeedButton(),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select a Tutorial',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // List of tutorial titles
          Expanded(
            child: ListView.separated(
              itemCount: _tutorialList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_fill, color: Colors.blueAccent),
                  title: Text(_tutorialList[index]['title']!),
                  onTap: () {
                    // FIX: Only load a new video if the player is ready
                    if (_isPlayerReady) {
                      _controller.load(_tutorialList[index]['videoId']!);
                    } else {
                      // Optional: Show a quick message if tapped too fast
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Player is still loading... Please wait.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}