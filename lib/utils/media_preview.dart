import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/custom_video_player.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<MediaModel> mediaList;
  final int initialIndex;
  final Function(int)? onRemove;

  const MediaViewerScreen({
    super.key,
    required this.mediaList,
    required this.initialIndex,
    this.onRemove,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> with AutomaticKeepAliveClientMixin{
  late PageController _pageController;
  late int currentIndex;
  VideoPlayerController? _videoController;

  MediaModel get currentMedia => widget.mediaList[currentIndex];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    if (!currentMediaIsImage) {
      _initializeVideo(currentMedia.url);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposeVideoController();
    super.dispose();
  }

  bool get currentMediaIsImage =>
      currentMedia.type == MediaType.image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${currentIndex + 1} / ${widget.mediaList.length}'),
        actions: [
          if (widget.onRemove != null)
            IconButton(
              onPressed: _removeCurrentItem,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaList.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          final media = widget.mediaList[index];
          if (media.type == MediaType.video) {
            _initializeVideo(media.url);
          } else {
            _disposeVideoController();
          }
        },
        itemBuilder: (context, index) {
          final media = widget.mediaList[index];
          return media.type == MediaType.image
              ? _buildImageView(media.url)
              : CustomVideoPlayer(fullPreview: true,controller: _videoController,isCurrentSlide: true,);
        },
      ),
    );
  }

  Widget _buildImageView(String imagePath) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 3.0,
        child: SizedBox.expand(
          child: Image.file(
            File(imagePath),
            // fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.error, color: Colors.white, size: 64),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoView(String videoPath) {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final controller = _videoController!;
    final isPlaying = controller.value.isPlaying;
    final duration = controller.value.duration;
    final position = controller.value.position;

    return GestureDetector(
      onTap: () {
        setState(() {
          isPlaying ? controller.pause() : controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fullscreen video
          Center(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),

          // Play icon
          if (!isPlaying)
            const Icon(
              Icons.play_circle_fill,
              size: 72,
              color: Colors.white,
            ),

          // Custom progress bar with time
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VideoProgressIndicator(
                    controller,
                    allowScrubbing: true,
                    padding: EdgeInsets.zero,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = duration.inHours;

    return hours > 0
        ? '${twoDigits(hours)}:$minutes:$seconds'
        : '$minutes:$seconds';
  }


  Future<void> _initializeVideo(String videoPath) async {
    _disposeVideoController();
    _videoController = VideoPlayerController.file(File(videoPath));
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    if (mounted) setState(() {});
  }

  void _disposeVideoController() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
  }

  void _removeCurrentItem() {
    widget.onRemove?.call(currentIndex);
    Navigator.of(context).pop();
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}
