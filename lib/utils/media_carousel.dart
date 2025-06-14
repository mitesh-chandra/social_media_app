import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/custom_video_player.dart';
import 'package:video_player/video_player.dart';

class MediaCarousel extends StatefulWidget {
  final List<MediaModel> mediaList;
  final bool enableFullscreen;
  final double aspectRatio;
  final BorderRadius? borderRadius;

  const MediaCarousel({
    super.key,
    required this.mediaList,
    this.enableFullscreen = true,
    this.aspectRatio = 2.0,
    this.borderRadius,
  });

  @override
  State<StatefulWidget> createState() {
    return _MediaCarouselState();
  }
}

class _MediaCarouselState extends State<MediaCarousel> with TickerProviderStateMixin {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final CarouselSliderController _carouselController = CarouselSliderController();
  final List<VideoPlayerController?> _videoControllers = [];
  final Map<int, bool> _mediaLoadingStates = {};

  late AnimationController _indicatorAnimationController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initVideoControllers();
    _initLoadingStates();
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    _indicatorAnimationController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _indicatorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _indicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _indicatorAnimationController,
      curve: Curves.easeInOut,
    ));

    _indicatorAnimationController.forward();
  }

  void _initLoadingStates() {
    for (int i = 0; i < widget.mediaList.length; i++) {
      _mediaLoadingStates[i] = true;
    }
  }

  void _initVideoControllers() {
    _videoControllers.clear();

    for (int i = 0; i < widget.mediaList.length; i++) {
      final media = widget.mediaList[i];
      if (media.type == MediaType.video && media.url.isNotEmpty) {
        final controller = VideoPlayerController.file(File(media.url));
        _videoControllers.add(controller);

        // Initialize video and update loading state
        controller.initialize().then((_) {
          if (mounted) {
            setState(() {
              _mediaLoadingStates[i] = false;
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _mediaLoadingStates[i] = false;
            });
          }
        });
      } else {
        _videoControllers.add(null);
        // For images, we'll update loading state when they load
      }
    }
  }

  void _disposeVideoControllers() {
    for (final controller in _videoControllers) {
      controller?.dispose();
    }
    _videoControllers.clear();
  }

  void _pauseAllVideos() {
    for (final controller in _videoControllers) {
      if (controller != null && controller.value.isInitialized) {
        controller.pause();
      }
    }
  }

  void _onPageChanged(int index) {
    HapticFeedback.lightImpact();
    _pauseAllVideos();
    _currentIndex.value = index;
  }

  void _navigateToFullscreen() {
    if (widget.enableFullscreen) {
      context.push(
        '${AppRouter.viewMedia}?index=${_currentIndex.value}',
        extra: (widget.mediaList, _videoControllers),
      );
    }
  }

  Widget _buildMediaItem(MediaModel media, int index) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ??
        const BorderRadius.vertical(top: Radius.circular(12));

    if (media.type == MediaType.image) {
      return _buildImageItem(media, index, borderRadius, theme);
    } else if (media.type == MediaType.video) {
      return _buildVideoItem(media, index, borderRadius, theme);
    }

    return _buildErrorItem(borderRadius, theme);
  }

  Widget _buildImageItem(MediaModel media, int index, BorderRadius borderRadius, ThemeData theme) {
    return GestureDetector(
      onTap: _navigateToFullscreen,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.file(
                File(media.url),
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    // Update loading state immediately for synchronous loading
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _mediaLoadingStates[index] = false;
                        });
                      }
                    });
                    return child;
                  }

                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    onEnd: () {
                      if (frame != null && mounted) {
                        setState(() {
                          _mediaLoadingStates[index] = false;
                        });
                      }
                    },
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _mediaLoadingStates[index] = false;
                      });
                    }
                  });
                  return _buildErrorContent(theme);
                },
              ),

              // Loading overlay
              if (_mediaLoadingStates[index] == true)
                _buildLoadingOverlay(theme),

              // Media type indicator
              Positioned(
                top: 12,
                left: 12,
                child: _buildMediaTypeChip(Icons.image_rounded, 'Photo', theme),
              ),

              // Tap to expand indicator
              if (widget.enableFullscreen)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildExpandButton(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoItem(MediaModel media, int index, BorderRadius borderRadius, ThemeData theme) {
    return GestureDetector(
      onTap: _navigateToFullscreen,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(
            children: [
              // Video Player
              CustomVideoPlayer(
                controller: _videoControllers[index],
                isCurrentSlide: _currentIndex.value == index,
              ),

              // Loading overlay for video
              if (_mediaLoadingStates[index] == true)
                _buildLoadingOverlay(theme),

              // Media type indicator
              Positioned(
                top: 12,
                left: 12,
                child: _buildMediaTypeChip(Icons.videocam_rounded, 'Video', theme),
              ),

              // Tap to expand indicator
              if (widget.enableFullscreen)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildExpandButton(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorItem(BorderRadius borderRadius, ThemeData theme) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHighest,
        child: _buildErrorContent(theme),
      ),
    );
  }

  Widget _buildErrorContent(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              size: 32,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load media',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha:0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Container(
      color: Colors.black.withValues(alpha:0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Loading...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTypeChip(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandButton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.fullscreen_rounded,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildModernIndicators(ThemeData theme) {
    if (widget.mediaList.length <= 1) return const SizedBox();

    return FadeTransition(
      opacity: _indicatorAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous button
            if (widget.mediaList.length > 3)
              ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, currentIndex, child) {
                  return AnimatedOpacity(
                    opacity: currentIndex > 0 ? 1.0 : 0.3,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: currentIndex > 0
                          ? () => _carouselController.previousPage()
                          : null,
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  );
                },
              ),

            // Indicators
            ...widget.mediaList.asMap().entries.map((entry) {
              return ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, currentIndex, child) {
                  final isActive = currentIndex == entry.key;
                  final isAdjacent = (currentIndex - entry.key).abs() == 1;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isActive ? 24 : isAdjacent ? 12 : 8,
                    height: isActive ? 8 : 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha:
                        isAdjacent ? 0.4 : 0.2,
                      ),
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha:0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                          : null,
                    ),
                  );
                },
              );
            }),

            // Next button
            if (widget.mediaList.length > 3)
              ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, currentIndex, child) {
                  return AnimatedOpacity(
                    opacity: currentIndex < widget.mediaList.length - 1 ? 1.0 : 0.3,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: currentIndex < widget.mediaList.length - 1
                          ? () => _carouselController.nextPage()
                          : null,
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaCounter(ThemeData theme) {
    if (widget.mediaList.length <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (context, currentIndex, child) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha:0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.collections_rounded,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha:0.7),
              ),
              const SizedBox(width: 6),
              Text(
                '${currentIndex + 1} of ${widget.mediaList.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha:0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.mediaList.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha:0.3),
              ),
              const SizedBox(height: 12),
              Text(
                'No media to display',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha:0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Carousel
        Expanded(
          child: CarouselSlider(
            items: widget.mediaList.asMap().entries.map((entry) {
              final index = entry.key;
              final media = entry.value;
              return _buildMediaItem(media, index);
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: widget.aspectRatio,
              enableInfiniteScroll: false,
              viewportFraction: 0.9,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              onPageChanged: (index, reason) => _onPageChanged(index),
            ),
          ),
        ),

        // Modern Indicators
        _buildModernIndicators(theme),

        // Media Counter
        _buildMediaCounter(theme),
      ],
    );
  }
}