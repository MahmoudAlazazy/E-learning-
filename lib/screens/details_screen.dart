import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const DetailsScreen({Key? key, required this.title, required this.videoUrl})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _controller;
  bool _isVideoAvailable = false;
  bool _isFullScreen = false;
  double _playbackSpeed = 1.0; // Default playback speed

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl != "No Video Available" && widget.videoUrl.isNotEmpty) {
      _isVideoAvailable = true;
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    if (_isVideoAvailable) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _seekForward() {
    _controller.seekTo(_controller.value.position + Duration(seconds: 10));
  }

  void _seekBackward() {
    _controller.seekTo(_controller.value.position - Duration(seconds: 10));
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controller.setPlaybackSpeed(speed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Full dark mode
      body: _isVideoAvailable
          ? Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Controls Overlay
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Video Seek Bar
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.blue,
                    bufferedColor: Colors.white54,
                    backgroundColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),

                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Rewind 10 Seconds
                    IconButton(
                      icon: Icon(Icons.replay_10, size: 40, color: Colors.white),
                      onPressed: _seekBackward,
                    ),

                    // Play/Pause
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),

                    // Forward 10 Seconds
                    IconButton(
                      icon: Icon(Icons.forward_10, size: 40, color: Colors.white),
                      onPressed: _seekForward,
                    ),
                  ],
                ),

                // Playback Speed Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Speed:", style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(width: 10),
                    DropdownButton<double>(
                      dropdownColor: Colors.black,
                      value: _playbackSpeed,
                      items: [
                        DropdownMenuItem(value: 0.5, child: Text("0.5x", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: 1.0, child: Text("1.0x", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: 1.5, child: Text("1.5x", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: 2.0, child: Text("2.0x", style: TextStyle(color: Colors.white))),
                      ],
                      onChanged: (speed) {
                        if (speed != null) _changePlaybackSpeed(speed);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back Button (Top Left)
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
