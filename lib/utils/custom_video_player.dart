import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    with TickerProviderStateMixin {
  bool _showControls = true;
  bool _isPlaying = false;
  bool _isDragging = false;
  double _dragPosition = 0.0;

  late AnimationController _controlsAnimationController;
  late AnimationController _playPauseAnimationController;
  late AnimationController _seekAnimationController;

  late Animation<double> _controlsAnimation;
  late Animation<double> _playPauseAnimation;
  late Animation<double> _seekAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _playPauseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _seekAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _controlsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    ));

    _playPauseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _playPauseAnimationController,
      curve: Curves.elasticOut,
    ));

    _seekAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _seekAnimationController,
      curve: Curves.easeOut,
    ));

    if (widget.controller != null) {
      widget.controller!.addListener(_videoListener);
    }

    _controlsAnimationController.forward();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_videoListener);
    _controlsAnimationController.dispose();
    _playPauseAnimationController.dispose();
    _seekAnimationController.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (mounted && widget.controller != null) {
      setState(() {
        _isPlaying = widget.controller!.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return;
    }

    HapticFeedback.lightImpact();

    // Animate play/pause button
    _playPauseAnimationController.forward().then((_) {
      _playPauseAnimationController.reverse();
    });

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
        if (mounted && _isPlaying && !_isDragging) {
          setState(() {
            _showControls = false;
          });
          _controlsAnimationController.reverse();
        }
      });
    }
  }

  void _onVideoTap() {
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

  void _onDoubleTap() {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return;
    }

    HapticFeedback.mediumImpact();

    // Seek forward 10 seconds
    final currentPosition = widget.controller!.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    final maxPosition = widget.controller!.value.duration;

    widget.controller!.seekTo(
      newPosition > maxPosition ? maxPosition : newPosition,
    );

    // Show seek animation
    _seekAnimationController.forward().then((_) {
      _seekAnimationController.reverse();
    });

    _showControlsTemporarily();
  }

  void _onProgressDragStart(double position) {
    setState(() {
      _isDragging = true;
      _dragPosition = position;
    });

    // Show controls while dragging
    setState(() {
      _showControls = true;
    });
    _controlsAnimationController.forward();
  }

  void _onProgressDragUpdate(double position) {
    setState(() {
      _dragPosition = position;
    });
  }

  void _onProgressDragEnd() {
    if (widget.controller != null && widget.controller!.value.isInitialized) {
      final duration = widget.controller!.value.duration;
      final newPosition = Duration(
        milliseconds: (duration.inMilliseconds * _dragPosition).round(),
      );
      widget.controller!.seekTo(newPosition);
    }

    setState(() {
      _isDragging = false;
    });

    _showControlsTemporarily();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return hours > 0
        ? '${twoDigits(hours)}:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: widget.fullPreview ? null : BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: widget.fullPreview ? null : BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.play_disabled_rounded,
                size: 32,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Video Error',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Unable to play video',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomProgressIndicator() {
    if (widget.controller == null || !widget.controller!.value.isInitialized) {
      return const SizedBox();
    }

    final duration = widget.controller!.value.duration;
    final position = _isDragging
        ? Duration(milliseconds: (duration.inMilliseconds * _dragPosition).round())
        : widget.controller!.value.position;
    final buffered = widget.controller!.value.buffered;

    final progress = position.inMilliseconds / duration.inMilliseconds.clamp(1, double.infinity);

    return LayoutBuilder(
      builder: (context, constraints) {
        final progressWidth = constraints.maxWidth;
        final thumbPosition = (progress.isNaN ? 0.0 : progress) * progressWidth;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragStart: (_) {
            setState(() => _isDragging = true);
          },
          onHorizontalDragUpdate: (details) {
            final localDx = details.localPosition.dx.clamp(0.0, progressWidth);
            final relative = localDx / progressWidth;
            setState(() => _dragPosition = relative);
          },
          onHorizontalDragEnd: (_) {
            final newPosition = Duration(
              milliseconds: (duration.inMilliseconds * _dragPosition).round(),
            );
            widget.controller!.seekTo(newPosition);
            setState(() => _isDragging = false);
          },
          onTapDown: (details) {
            final relative = details.localPosition.dx / progressWidth;
            final newPosition = Duration(
              milliseconds: (duration.inMilliseconds * relative).round(),
            );
            widget.controller!.seekTo(newPosition);
          },
          child: SizedBox(
            height: 24,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background track
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Buffered track
                if (buffered.isNotEmpty)
                  FractionallySizedBox(
                    widthFactor: buffered.last.end.inMilliseconds /
                        duration.inMilliseconds.clamp(1, double.infinity),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                // Progress bar
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Circular thumb aligned with progress
                Positioned(
                  left: thumbPosition.clamp(0.0, progressWidth - 6),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildPlayPauseButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildSeekIndicator() {
    return AnimatedBuilder(
      animation: _seekAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _seekAnimation.value,
          child: Transform.scale(
            scale: _seekAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fast_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '+10s',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return _buildErrorState();
    }

    if (!widget.controller!.value.isInitialized) {
      return _buildLoadingState();
    }

    return ClipRRect(
      borderRadius: widget.fullPreview ? BorderRadius.zero : BorderRadius.circular(12),
      child: GestureDetector(
        onTap: widget.fullPreview ? _onVideoTap : _togglePlayPause,
        onDoubleTap: widget.fullPreview ? _onDoubleTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: widget.fullPreview ? null : BorderRadius.circular(12),
          ),
          child: Stack(
            // alignment: Alignment.center,

            children: [
              // Video player
              Center(
                child: AspectRatio(
                  aspectRatio: widget.controller!.value.aspectRatio,
                  child: VideoPlayer(widget.controller!),
                ),
              ),

              // Controls overlay
              if (widget.fullPreview || !_isPlaying)
                AnimatedBuilder(
                  animation: _controlsAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: widget.fullPreview ? _controlsAnimation.value : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: widget.fullPreview
                              ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha:0.4),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withValues(alpha:0.6),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          )
                              : null,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: widget.fullPreview
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      // Top spacing for fullPreview
                      if (widget.fullPreview) const Spacer(),

                      // Play/Pause button
                      Center(child: _buildPlayPauseButton()),

                      // Seek indicator
                      if (widget.fullPreview)
                        _buildSeekIndicator(),

                      // Bottom controls for fullPreview
                      if (widget.fullPreview) ...[
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            12,12,12,40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 4,
                            children: [
                              Text(
                                _formatDuration(_isDragging
                                    ? Duration(milliseconds: (widget.controller!.value.duration.inMilliseconds * _dragPosition).round())
                                    : widget.controller!.value.position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onPanStart: (details) {
                                    final box = context.findRenderObject() as RenderBox;
                                    final localPosition = box.globalToLocal(details.globalPosition);
                                    final progress = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                                    _onProgressDragStart(progress);
                                  },
                                  onPanUpdate: (details) {
                                    final box = context.findRenderObject() as RenderBox;
                                    final localPosition = box.globalToLocal(details.globalPosition);
                                    final progress = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
                                    _onProgressDragUpdate(progress);
                                  },
                                  onPanEnd: (details) {
                                    _onProgressDragEnd();
                                  },
                                  child: Container(
                                    height: 20,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: _buildCustomProgressIndicator(),
                                  ),
                                ),
                              ),
                              Text(
                                _formatDuration(widget.controller!.value.duration),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha:0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),

              // Video duration overlay for non-fullPreview
              if (!widget.fullPreview && !_isPlaying)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(widget.controller!.value.duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pause video when not current slide
    if (!widget.isCurrentSlide && _isPlaying) {
      widget.controller?.pause();
    }

    // Update listener when controller changes
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_videoListener);
      widget.controller?.addListener(_videoListener);
    }
  }
}