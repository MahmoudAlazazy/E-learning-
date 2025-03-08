import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const DetailsScreen({Key? key, required this.title, required this.videoUrl})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoAvailable = false;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl.isNotEmpty && widget.videoUrl != "No Video Available") {
      _isVideoAvailable = true;
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();
    _videoPlayerController.setVolume(1.0); // Ensure sound is enabled

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        bufferedColor: Colors.grey,
        backgroundColor: Colors.black54,
      ),
    );

    setState(() {}); // Refresh UI after initialization
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: _isVideoAvailable
          ? Center(
        child: _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : CircularProgressIndicator(),
      )
          : Center(
        child: Text(
          "No Video Available",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
