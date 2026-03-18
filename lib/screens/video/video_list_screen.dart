import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';


class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<AssetEntity> videos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> loadVideos() async {
    try {
      debugPrint("PhotoManager: Requesting permissions...");
      
      // Try to request permissions. If this fails with MissingPluginException, 
      // it means the native part is not linked.
      PermissionState permission;
      try {
        permission = await PhotoManager.requestPermissionExtend();
      } on MissingPluginException {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = "Native Plugin Error: Please run 'flutter clean' and 'flutter run' to link the video gallery.";
          });
        }
        return;
      }

      debugPrint("PhotoManager: Permission status: $permission");

      if (permission.isAuth || permission.hasAccess) {
        List<AssetPathEntity> albums =
            await PhotoManager.getAssetPathList(type: RequestType.video);

        if (albums.isNotEmpty) {
          List<AssetEntity> media =
              await albums.first.getAssetListPaged(page: 0, size: 100);

          if (mounted) {
            setState(() {
              videos = media;
              isLoading = false;
              errorMessage = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              errorMessage = "No video albums found on device";
            });
          }
        }
      } else {
        PhotoManager.openSetting();
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = "Permission denied. Please grant media access.";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading videos: ${e.toString()}";
        });
      }
      debugPrint("PhotoManager Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Phone Videos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: videos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildSampleVideoCard();
                      }
                      final video = videos[index - 1];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                      child: FutureBuilder(
                        future: video.thumbnailData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const ListTile(
                              title: Text("Loading...",
                                  style: TextStyle(color: Colors.black54)),
                            );
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.memory(
                                    snapshot.data!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              video.title ?? "Video $index",
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              _formatDuration(video.duration),
                              style: const TextStyle(color: Colors.black54),
                            ),
                            onTap: () async {
                              final file = await video.file;
                              if (file != null && mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VideoPlayerScreen(
                                      videoPath: file.path,
                                      isAsset: false,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ));
                  },
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSampleVideoCard() {
    return Column(
      children: [
        _buildAssetVideoCard(
          title: "How to delete YouTube History",
          subtitle: "Featured Tutorial",
          path: "assets/videos/how to delete youtube history_ how to clear youtube search History #viral.mp4",
          icon: Icons.history,
        ),
        const SizedBox(height: 12),
        _buildAssetVideoCard(
          title: "Sample Video (App Asset)",
          subtitle: "Tap to play demo video",
          path: "assets/videos/new_video.mp4",
          icon: Icons.movie,
        ),
      ],
    );
  }

  Widget _buildAssetVideoCard({
    required String title,
    required String subtitle,
    required String path,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 70,
            height: 70,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).primaryColor, size: 30),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(
                videoPath: path,
                isAsset: true,
              ),
            ),
          );
        },
      ),
    ));
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String remainingSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final bool isAsset;

  const VideoPlayerScreen({
    super.key,
    required this.videoPath,
    this.isAsset = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isAsset) {
      _controller = VideoPlayerController.asset(widget.videoPath);
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath));
    }

    try {
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      }).catchError((e) {
        debugPrint("VideoPlayer Error during init: $e");
      });
    } on MissingPluginException {
      debugPrint("VideoPlayer Plugin not linked");
    } catch (e) {
      debugPrint("VideoPlayer general error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
