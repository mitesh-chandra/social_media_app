import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final VideoPlayerController? controller;
  final bool isCurrentSlide;
  final bool fullPreview;

  const CustomVideoPlayer({
    super.key,
    required this.controller,
    required this.isCurrentSlide,
    this.fullPreview = false,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  bool _isPlaying = false;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  @override
  void initState() {
    super.initState();
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controlsAnimationController);

    if (widget.controller != null) {
      widget.controller!.addListener(_videoListener);
    }
    _controlsAnimationController.forward();
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _isPlaying = widget.controller!.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return;
    }

    setState(() {
      if (_isPlaying && widget.fullPreview) {
        widget.controller!.pause();
      } else {
        _isPlaying = true;
        widget.controller!.play();
      }
    });
    if (widget.fullPreview) {
      _showControlsTemporarily();
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();

    // Hide controls after 3 seconds if playing
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
          _controlsAnimationController.reverse();
        }
      });
    }
  }

  void _onVideoTap() {
    // context.push(AppRouter.viewMedia,extra: widget.)
    if (_isPlaying) {
      if (_showControls) {
        setState(() {
          _showControls = false;
        });
        _controlsAnimationController.reverse();
      } else {
        _showControlsTemporarily();
      }
    } else {
      _togglePlayPause();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.error_outline, size: 50, color: Colors.grey),
        ),
      );
    }

    if (!widget.controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.fullPreview ? _onVideoTap : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          AspectRatio(
            aspectRatio: widget.controller!.value.aspectRatio,
            child: VideoPlayer(widget.controller!),
          ),

          // Controls overlay
          AnimatedBuilder(
            animation: _controlsAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _controlsAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: widget.fullPreview
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(),
                if (widget.fullPreview || !_isPlaying)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                // Bottom controls
                if (widget.fullPreview)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Current time
                          Text(
                            _formatDuration(widget.controller!.value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Progress bar
                          Expanded(
                            child: VideoProgressIndicator(
                              widget.controller!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.grey,
                                backgroundColor: Colors.white30,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                          // Total duration
                          Text(
                            _formatDuration(widget.controller!.value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isCurrentSlide && _isPlaying) {
      widget.controller?.pause();
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_videoListener);
      widget.controller?.addListener(_videoListener);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_videoListener);
    _controlsAnimationController.dispose();
    super.dispose();
  }
}
