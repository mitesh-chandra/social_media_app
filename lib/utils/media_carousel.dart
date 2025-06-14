import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/custom_video_player.dart';
import 'package:video_player/video_player.dart';

class MediaCarousel extends StatefulWidget {
  final List<MediaModel> mediaList;
  const MediaCarousel({super.key, required this.mediaList});

  @override
  State<StatefulWidget> createState() {
    return _MediaCarouselState();
  }
}

class _MediaCarouselState extends State<MediaCarousel> {
  // int _current = 0;
  final valueListenable = ValueNotifier<int>(0);
  final CarouselSliderController _controller = CarouselSliderController();
  final List<VideoPlayerController?> _videoControllers = [];

  void _initVideoControllers() {
    _videoControllers.clear();

    for (int i = 0; i < widget.mediaList.length; i++) {
      final media = widget.mediaList[i];
      if (media.type == MediaType.video && media.url.isNotEmpty) {
        final controller = VideoPlayerController.file(File(media.url));
        _videoControllers.add(controller);
        controller.initialize();
      } else {
        _videoControllers.add(null);
      }
    }
  }

  void _pauseAllVideos() {
    for (final controller in _videoControllers) {
      if (controller != null && controller.value.isInitialized) {
        controller.pause();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: CarouselSlider(
          items: widget.mediaList.asMap().entries.map((entry) {
            final index = entry.key;
            final media = entry.value;

            if (media.type == MediaType.image) {
              return InkWell(
                onTap: ()=>context.push(AppRouter.viewMedia,extra: widget.mediaList),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.file(
                    File(media.url),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (media.type == MediaType.video) {
              return InkWell(
                onTap: ()=>context.push(AppRouter.viewMedia,extra: widget.mediaList),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomVideoPlayer(
                    controller: _videoControllers[index],
                    isCurrentSlide: valueListenable.value == index,
                  ),
                ),
              );
            }

            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              // Pause all videos when changing slides
              _pauseAllVideos();
              valueListenable.value = index;
            },
          ),
        ),
      ),
      if (widget.mediaList.length > 1)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.mediaList.asMap().entries.map((entry) {
            return ValueListenableBuilder(
              valueListenable: valueListenable,
              builder: (context, value, child) {
                return Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withValues(alpha: value == entry.key ? 0.9 : 0.4),
                  ),
                );
              }
            );
          }).toList(),
        ),
    ]);
  }

  @override
  void dispose() {
    for (final controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }
}
