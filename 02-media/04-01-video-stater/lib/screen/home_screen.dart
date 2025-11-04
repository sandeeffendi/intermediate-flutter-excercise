import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer_project/provider/video_notifier.dart';
import 'package:videoplayer_project/utils/utils.dart';

import '../widget/buffer_slider_controller_widget.dart';
import '../widget/video_controller_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController? controller;
  bool isVideoInitialize = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  void initializeVideo() async {
    final previousVideoController = controller;
    final provider = context.read<VideoNotifier>();
    final url = Uri.parse(
        'https://github.com/dicodingacademy/assets/releases/download/release-video/VideoDicoding.mp4');

    final videoController = VideoPlayerController.networkUrl(url);

    await previousVideoController?.dispose();

    try {
      await videoController.initialize();
    } catch (e) {
      throw 'Failed to initialize video player: $e';
    }

    if (mounted) {
      setState(() {
        controller = videoController;
        isVideoInitialize = controller!.value.isInitialized;
      });
    }
    if (isVideoInitialize && controller != null) {
      controller?.addListener(() {
        provider.duration = controller!.value.duration;
        provider.isPlay = controller!.value.isPlaying;
        provider.position = controller!.value.position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player Project"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // video screen
          isVideoInitialize
              ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(controller!))
              : const CircularProgressIndicator(),

          // Video controller bottom widget
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // buffer slider
                Consumer<VideoNotifier>(
                    builder: (context, videoProvider, child) {
                  final duration = videoProvider.duration;
                  final position = videoProvider.position;

                  return BufferSliderControllerWidget(
                    maxValue: duration.inSeconds.toDouble(),
                    currentValue: position.inSeconds.toDouble(),
                    minText: durationToTimeString(duration),
                    maxText: durationToTimeString(position),
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await controller?.seekTo(newPosition);

                      await controller?.play();
                    },
                  );
                }),
                Consumer<VideoNotifier>(
                    builder: (context, videoProvider, child) {
                  final isPlay = videoProvider.isPlay;

                  return VideoControllerWidget(
                    onPlayTapped: () {
                      controller?.play();
                    },
                    onPauseTapped: () {
                      controller?.pause();
                    },
                    isPlay: isPlay,
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
