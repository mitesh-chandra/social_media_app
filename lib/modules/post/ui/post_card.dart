import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/utils/media_carousel.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';

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

class _PostCardState extends State<PostCard> with TickerProviderStateMixin {
  late bool isOwner;
  final PageController _pageController = PageController();
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    isOwner = widget.post.userId == UserDb.getCurrentUser()?.id;

    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _likeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _likeAnimationController.dispose();
    super.dispose();
  }

  Widget _buildMediaCarousel() {
    if (widget.post.media.isEmpty) return const SizedBox();

    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: MediaCarousel(
        mediaList: widget.post.media,
      ),
    );
  }

  Widget _buildPostHeader() {
    final theme = Theme.of(context);
    final user = UserDb.getUser(widget.post.userId);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Enhanced User Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              child: user?.profilePath != null
                  ? ClipOval(
                child: Image.file(
                  File(user!.profilePath!),
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(theme),
                ),
              )
                  : _buildDefaultAvatar(theme),
            ),
          ),

          const SizedBox(width: 12),

          // Enhanced User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name.toUpperCase() ?? 'APP USER',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimeAgo(widget.post.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Enhanced Options Menu
          if (isOwner)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: theme.colorScheme.error,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Delete Post',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Icon(
      Icons.person_rounded,
      color: theme.colorScheme.onPrimary,
      size: 24,
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Delete Post',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this post? This action cannot be undone.',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PostBloc>().deletePostEvent(widget.post.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Delete',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostContent() {
    final theme = Theme.of(context);

    if (widget.post.title.isEmpty && widget.post.body.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.title.isNotEmpty)
            Text(
              widget.post.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
          if (widget.post.body.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: widget.post.title.isNotEmpty ? 8 : 0),
              child: Text(
                widget.post.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('${AppRouter.postDetail}?postId=${widget.post.id}');
          },
          child: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              // Handle state changes if needed
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header with user info
                _buildPostHeader(),

                // Media Carousel
                _buildMediaCarousel(),

                // Post Content
                _buildPostContent(),

                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PostActionButton(
                          icon: widget.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          iconColor: widget.isLiked ? Colors.red : null,
                          label: widget.post.likeCount.toString(),
                          onTap: () {
                            if (widget.isLiked) {
                              _likeAnimationController.forward().then((_) {
                                _likeAnimationController.reverse();
                              });
                            }
                            context.read<PostBloc>().toggleLikeEvent(
                              isLiked: !widget.isLiked,
                              postId: widget.post.id,
                            );
                          },
                          animation: _likeAnimation,
                        ),
                      ),
                      Expanded(
                        child: _PostActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: widget.post.commentCount.toString(),
                          onTap: () {
                            context.push('${AppRouter.postDetail}?postId=${widget.post.id}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
  final Animation<double>? animation;

  const _PostActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildIcon() {
      final baseIcon = Icon(
        icon,
        size: 20,
        color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
      );

      if (animation != null) {
        return AnimatedBuilder(
          animation: animation!,
          builder: (context, child) {
            return Transform.scale(
              scale: animation!.value,
              child: baseIcon,
            );
          },
        );
      }

      return baseIcon;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIcon(),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}