import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/media_carousel.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final bool isLiked;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final List<VideoPlayerController> _videoControllers = [];
  // late bool isLiked;
  late bool isOwner;
  final PageController _pageController = PageController();
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();

    // isLiked = widget.post.likes.any((like) => like.userId == UserDb.getCurrentUser()?.id);
    isOwner = widget.post.userId == UserDb.getCurrentUser()?.id;

    _initVideoControllers();
  }

  void _initVideoControllers() {
    _videoControllers.clear();

    for (int i = 0; i < widget.post.media.length; i++) {
      final media = widget.post.media[i];
      if (media.type == MediaType.video && media.url.isNotEmpty) {
        final controller = VideoPlayerController.file(File(media.url))
          ..initialize().then((_) {
            // if (mounted) setState(() {});
          });
        _videoControllers.add(controller);
      } else {
        _videoControllers.add(VideoPlayerController.file(File(''))); // Placeholder
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildMediaCarousel() {
    if (widget.post.media.isEmpty) return const SizedBox();

    return SizedBox(
      height: 300,
      child:
      MediaCarousel(mediaList:widget.post.media,),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserDb.getUser(widget.post.userId)?.name.toUpperCase() ?? 'APP USER',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatTimeAgo(widget.post.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Options Menu (only for post owner)
          if (isOwner)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[600]),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Post', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PostBloc>().deletePostEvent(widget.post.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('${AppRouter.postDetail}?postId=${widget.post.id}');
      },
      child: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          // switch (state) {
          //   // case LikeToggled():
          //   //   if (state.id == widget.post.id) {
          //   //     widget.isLiked = !widget.isLiked;
          //   //   }
          //   default:
          // }
        },
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header with user info
              _buildPostHeader(),

              // Media Carousel
              InkWell(
                child: _buildMediaCarousel(),
                // onTap: () => context.push(
                //   AppRouter.viewMedia,
                //   extra: widget.post.media,
                // ),
              ),

              // Post Content
              if (widget.post.title.isNotEmpty || widget.post.body.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.post.title.isNotEmpty)
                        Text(
                          widget.post.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      if (widget.post.body.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            widget.post.body,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                    ],
                  ),
                ),

              const Divider(height: 1),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PostActionButton(
                    icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    iconColor: widget.isLiked ? Colors.red : null,
                    label: widget.post.likeCount.toString(),
                    onTap: () {
                      context.read<PostBloc>().toggleLikeEvent(
                        isLiked: !widget.isLiked,
                        postId: widget.post.id,
                      );
                    },
                  ),
                  _PostActionButton(
                    icon: Icons.comment_outlined,
                    label: widget.post.comments.length.toString(),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _PostActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor ?? Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}