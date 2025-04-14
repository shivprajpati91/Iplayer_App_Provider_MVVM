import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

class PlayScreen extends StatefulWidget {
  final String? videoPath;
  const PlayScreen({Key? key, this.videoPath}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  final Box box = Hive.box('videoBox');

  double _brightness = 0.5;
  double _volume = 0.5;
  double _startY = 0;
  double _startValue = 0;
  bool _isBrightnessControl = true;
  bool _showOverlay = false;
  String _overlayText = "";
  bool _isPaused = false;
  double _startX = 0;
  bool _isSeeking = false;
  bool _isLocked = false; // 🔒 Lock state
// Controls visibility of lock button

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null) {
      _initializePlayer(File(widget.videoPath!));
      _addVideoToRecent(widget.videoPath!);
      _initScreenSettings();
    } else {
      print("Error: Video path is null");
    }
  }
  void _initializePlayer(File videoFile) async {
    try {
      _controller = VideoPlayerController.file(videoFile);
      await _controller!.initialize();

      if (!mounted) return;

      // Get video dimensions
      int videoWidth = _controller!.value.size.width.toInt();
      int videoHeight = _controller!.value.size.height.toInt();

      // Check if the video is 1920x1080 (Full HD Landscape)
      bool isFullHD = (videoWidth == 1920 && videoHeight == 1080);

      // Check if aspect ratio is wider than tall
      bool isLandscape = _controller!.value.aspectRatio > 1;

      if (isFullHD || isLandscape) {
        _enterFullScreen(); // Force Landscape Mode for Full HD or Landscape videos
      } else {
        _exitFullScreen(); // Portrait Mode for other videos
      }

      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        showControls: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        playbackSpeeds: [0.5, 1.0, 1.5, 2.0],
      );

      setState(() {});
    } catch (error) {
      print("Error initializing video: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load video. Please try again.")),
      );
    }
  }




  /// 🌟 Adjust full-screen mode dynamically
  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,

    ]);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }



  /// Initialize brightness and volume
  Future<void> _initScreenSettings() async {
    _brightness = await ScreenBrightness().current;
    _volume = await VolumeController().getVolume();
    setState(() {});
  }

  /// Handle vertical swipe start (Brightness/Volume)
  void _onVerticalDragStart(DragStartDetails details) async {
    if (_isLocked) return; // 🔒 Ignore when locked

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    _startY = details.globalPosition.dy;

    bool isLandscape = screenWidth > screenHeight;

    if ((isLandscape && details.globalPosition.dx < screenHeight / 3) ||
        (!isLandscape && details.globalPosition.dx < screenWidth / 3)) {
      _isBrightnessControl = true;
      _startValue = await ScreenBrightness().current;
      _overlayText = "Brightness";
    } else if ((isLandscape && details.globalPosition.dx > 2 * screenHeight / 3) ||
        (!isLandscape && details.globalPosition.dx > 2 * screenWidth / 3)) {
      _isBrightnessControl = false;
      _startValue = await VolumeController().getVolume();
      _overlayText = "Volume";
    } else {
      return;
    }

    setState(() => _showOverlay = true);
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isLocked) return; // 🔒 Ignore when locked

    double dragDistance = (_startY - details.globalPosition.dy) / 300;

    if (_isBrightnessControl) {
      _brightness = (_startValue + dragDistance).clamp(0.0, 1.0);
      ScreenBrightness().setScreenBrightness(_brightness);
      _overlayText = "Brightness: ${(100 * _brightness).toInt()}%";
    } else {
      _volume = (_startValue + dragDistance).clamp(0.0, 1.0);

      /// ✅ **Use System Volume Instead of Custom**
      VolumeController().setVolume(_volume);

      /// ✅ **Trigger System Volume Overlay**
      SystemSound.play(SystemSoundType.click);

      _overlayText = "Volume: ${(100 * _volume).toInt()}%";
    }

    setState(() {});
  }


  /// Hide overlay after interaction ends
  void _onVerticalDragEnd(DragEndDetails details) {
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showOverlay = false);
    });
  }

  /// Handle Tap for Pause/Play
  void _onTap() {
    if (_isLocked || _controller == null) return; // 🔒 Ignore when locked

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPaused = true;
      } else {
        _controller!.play();
        _isPaused = false;
      }
    });
  }



  /// Add video to recent history
  void _addVideoToRecent(String videoPath) {
    List<String> recentVideos = box.get('recentVideos', defaultValue: [])?.cast<String>() ?? [];

    if (!recentVideos.contains(videoPath)) {
      recentVideos.insert(0, videoPath);
      if (recentVideos.length > 20) recentVideos = recentVideos.sublist(0, 20);
      box.put('recentVideos', recentVideos);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    _exitFullScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortraitVideo = _controller != null &&
        _controller!.value.isInitialized &&
        (_controller!.value.rotationCorrection == 90 || _controller!.value.rotationCorrection == 270 || _controller!.value.aspectRatio < 1);

    return WillPopScope(
      onWillPop: () async {
        _exitFullScreen();
        return true;
      },
      child: GestureDetector(
        onTap: _onTap,
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: _controller != null && _controller!.value.isInitialized
                ? RotatedBox(
              quarterTurns: _controller!.value.rotationCorrection ~/ 90,
              child: AspectRatio(
                aspectRatio: isPortraitVideo ? (9 / 16) : _controller!.value.aspectRatio, // Keep correct aspect ratio
                child: Chewie(controller: _chewieController!),
              ),
            )
                : CircularProgressIndicator(color: Colors.purpleAccent),
          ),
        ),
      ),
    );
  }
}