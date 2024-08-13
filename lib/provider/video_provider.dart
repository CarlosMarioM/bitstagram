import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControllerProvider with ChangeNotifier {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  Future<void> initialize(String url) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);

    notifyListeners();
  }

  VideoPlayerController? get controller => _controller;
  Future<void>? get initializeVideoPlayerFuture => _initializeVideoPlayerFuture;

  void play() {
    if (_controller != null) {
      _controller!.play();
      notifyListeners();
    }
  }

  void pause() {
    if (_controller != null) {
      _controller!.pause();
      notifyListeners();
    }
  }

  void toggleMute() {
    if (_controller != null) {
      _controller!.setVolume(_controller!.value.volume == 0 ? 1.0 : 0.0);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
