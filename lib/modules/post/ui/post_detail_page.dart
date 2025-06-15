import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/db/post_db.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/post/ui/nested_comment_widget.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/utils/media_carousel.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> with TickerProviderStateMixin {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  final PageController _pageController = PageController();
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  late final PostModel? post;
  late final UserModel? postUser;
  late bool isLiked;
  late bool isOwner;
  late final String userInitials;

  @override
  void initState() {
    super.initState();
    post = PostDb.getPost(widget.postId);
    if (post != null) {
      postUser = UserDb.getUser(post!.userId);
      isLiked = post!.likes.any(
            (like) => like.userId == getStringAsync(AppConstant.userId),
      );
      isOwner = post!.userId == getStringAsync(AppConstant.userId);
    }
    userInitials = _getUserInitials(postUser?.name ?? 'User');

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

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose();
    _likeAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Widget _buildUserAvatar(String initials, ThemeData theme) {
    return Container(
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
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
        child: postUser?.profilePath != null
            ? ClipOval(
          child: Image.file(
            File(postUser!.profilePath!),
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(initials, theme),
          ),
        )
            : _buildDefaultAvatar(initials, theme),
      ),
    );
  }

  Widget _buildDefaultAvatar(String initials, ThemeData theme) {
    return Text(
      initials,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDeleteButton(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.delete_outline_rounded,
          color: theme.colorScheme.error,
          size: 22,
        ),
        onPressed: () => _showDeleteDialog(context, post!.id),
        tooltip: 'Delete Post',
      ),
    );
  }

  Widget _buildPostNotFound(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.post_add_rounded,
              size: 40,
              color: theme.colorScheme.error.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Post Not Found',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This post may have been deleted or moved.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<PostBloc>().replyToCommentEvent(null, null);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.article_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Post Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          actions: isOwner && post != null ? [_buildDeleteButton(theme)] : null,
        ),
        body: post == null
            ? _buildPostNotFound(theme)
            : BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            switch (state) {
              case LikeToggled():
                setState(() {
                  isLiked = !isLiked;
                });
                if (isLiked) {
                  _likeAnimationController.forward().then((_) {
                    _likeAnimationController.reverse();
                  });
                }
              case PostDeleted():
                GoRouter.of(context).pop();
                GoRouter.of(context).pop();
              case CommentAdded():
                _commentController.clear();
                context.read<PostBloc>().replyToCommentEvent(null, null);
              case PostError():
                showMessageDialog(context: context, message: state.error);
              default:
            }
          },
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserHeader(userInitials, postUser?.name ?? 'User', theme),
                        _buildPostContent(theme),
                        _buildMediaContent(),
                        _buildLikeCommentRow(theme),
                        const SizedBox(height: 16),
                        _buildCommentsSection(theme),
                      ],
                    ),
                  ),
                ),
                _buildCommentInput(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(String initials, String name, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          _buildUserAvatar(initials, theme),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDateTime(post?.createdAt ?? DateTime.now()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(ThemeData theme) {
    if (post!.title.plainText.isEmpty && post!.body.plainText.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post!.title.plainText.isNotEmpty)
            _buildRichTextDisplay(
              content: post!.title,
              defaultStyle: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
          if (post!.title.plainText.isNotEmpty && post!.body.plainText.isNotEmpty)
            const SizedBox(height: 12),
          if (post!.body.plainText.isNotEmpty)
            _buildRichTextDisplay(
              content: post!.body,
              defaultStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRichTextDisplay({
    required RichTextContent content,
    TextStyle? defaultStyle,
  }) {
    return RichText(
      text: _mergeDefaultStyleWithContent(content, defaultStyle),
      textAlign: TextAlign.start,
    );
  }

  TextSpan _mergeDefaultStyleWithContent(RichTextContent content, TextStyle? defaultStyle) {
    if (content.segments.isEmpty) {
      return TextSpan(
        text: content.plainText,
        style: defaultStyle,
      );
    }

    final List<TextSpan> spans = [];
    for (final segment in content.segments) {
      final TextStyle mergedStyle = defaultStyle?.merge(segment.formatting.toTextStyle()) ??
          segment.formatting.toTextStyle();

      spans.add(TextSpan(
        text: segment.text,
        style: mergedStyle,
      ));
    }

    return TextSpan(children: spans);
  }

  Widget _buildMediaContent() {
    if (post?.media.isEmpty ?? true) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: MediaCarousel(mediaList: post?.media ?? []),
        ),
      ),
    );
  }

  Widget _buildLikeCommentRow(ThemeData theme) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  iconColor: isLiked ? Colors.red : null,
                  label: '${post!.likeCount}',
                  onTap: () {
                    context.read<PostBloc>().toggleLikeEvent(
                      isLiked: !isLiked,
                      postId: post!.id,
                    );
                  },
                  theme: theme,
                  withAnimation: true,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post!.commentCount} Comments',
                  onTap: () {
                    _focusNode.requestFocus();
                  },
                  theme: theme,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    Color? iconColor,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
    bool withAnimation = false,
  }) {
    Widget iconWidget = Icon(
      icon,
      size: 22,
      color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
    );

    if (withAnimation) {
      iconWidget = AnimatedBuilder(
        animation: _likeAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _likeAnimation.value,
            child: Icon(
              icon,
              size: 22,
              color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(ThemeData theme) {
    return BlocBuilder<PostBloc,PostState>(
      builder: (context,state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.comment_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Comments (${post!.commentCount})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (post!.comments.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 48,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No comments yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to share your thoughts!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...post!.comments.map(
                    (comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: NestedCommentWidget(
                    comment: comment,
                    onReply: (commentId, userName) {
                      context.read<PostBloc>().replyToCommentEvent(commentId, userName);
                      _focusNode.requestFocus();
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.store.replyingToCommentId != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Replying to @${state.store.replyingToUser}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            context.read<PostBloc>().replyToCommentEvent(null, null);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Share your thoughts...',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          context.read<PostBloc>().addCommentEvent(
                            comment: _commentController.text.trim(),
                            postId: post!.id,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDateTime(DateTime time) =>
      '${time.day}/${time.month}/${time.year}';

  void _showDeleteDialog(BuildContext context, String postId) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            onPressed: () => GoRouter.of(context).pop(),
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
              context.read<PostBloc>().deletePostEvent(postId);
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
      ),
    );
  }
}