import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/db/post_db.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/utils/media_carousel.dart';
import 'package:social_media_app/utils/message_dialog.dart';
import 'package:video_player/video_player.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  final List<VideoPlayerController> _videoControllers = [];
  final PageController _pageController = PageController();
  int _currentMediaIndex = 0;

  // late final UserModel? currentUser;
  late final PostModel? post;
  late final UserModel? postUser;
  late bool isLiked;
  late bool isOwner;
  late final String userInitials;

  void _initVideoControllers() {
    _videoControllers.clear();

    if (post?.media != null) {
      for (int i = 0; i < post!.media.length; i++) {
        final media = post!.media[i];
        if (media.type == MediaType.video && media.url.isNotEmpty) {
          final controller = VideoPlayerController.file(File(media.url))
            ..initialize().then((_) {
              if (mounted) setState(() {});
            });
          _videoControllers.add(controller);
        } else {
          _videoControllers.add(VideoPlayerController.file(File(''))); // Placeholder
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // currentUser = UserDb.getCurrentUser();
    post = PostDb.getPost(widget.postId);
    if (post != null) {
      postUser = UserDb.getUser(post!.userId);
      isLiked = post!.likes.any((like) => like.userId == getStringAsync(AppConstant.userId));
      isOwner = post!.userId == getStringAsync(AppConstant.userId);
    }
    userInitials= _getUserInitials(postUser?.name ?? 'User');
    _initVideoControllers();
  }

  @override
  void dispose() {
    _commentController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: isOwner && post != null
            ? [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, post!.id),
          ),
        ]
            : null,
      ),
      body:post == null ? const Center(child: Text('Post not found')): BlocListener<PostBloc,PostState>(
        listener: (context,state){
          switch(state){
            case LikeToggled():
              isLiked = !isLiked;
            case PostDeleted():
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 1),
              ));
              GoRouter.of(context).pop();
              GoRouter.of(context).pop();
            case PostError():
              showMessageDialog(context: context, message: state.error);
            default:
          }
        },
        child:Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserHeader(userInitials, postUser?.name ?? 'User'),
                    if (post!.title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          post!.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    if (post!.body.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(post!.body),
                      ),
                    const SizedBox(height: 12),
                    _buildMediaContent(),
                    _buildLikeCommentRow(),
                    const Divider(),
                    _buildCommentsSection(),
                  ],
                ),
              ),
            ),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(String initials, String name) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 16))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                _formatDateTime(post?.createdAt ?? DateTime.now()),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaContent() {
    return InkWell(
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,child: MediaCarousel(mediaList: post?.media ?? [])),
      onTap: () => context.push(AppRouter.viewMedia, extra: post?.media ?? []),
    );
  }

  Widget _buildLikeCommentRow() {
    return BlocBuilder<PostBloc,PostState>(
        builder: (context,state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<PostBloc>().toggleLikeEvent(isLiked: !isLiked, postId: post!.id);
                  },
                ),
                Text(
                  '${post!.likes.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.comment_outlined, size: 24, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${post!.comments.length} Comments',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildCommentsSection() {
    if (post!.comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No comments yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Comments (${post!.comments.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...post!.comments.map((comment) => _buildCommentCard(comment)),
      ],
    );
  }

  Widget _buildCommentCard(CommentModel comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child: Text(
                      UserDb.getUser(comment.userId)?.name[0].toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    UserDb.getUser(comment.userId)?.name.toUpperCase() ?? 'USER',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Text(
                  _formatDateTime(comment.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            if (comment.replies.isNotEmpty)
              ...comment.replies.map(
                    (reply) => Container(
                  margin: const EdgeInsets.only(left: 24, top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.blue,
                            child: Text(
                              UserDb.getUser(comment.userId)?.name[0].toUpperCase() ?? 'U',
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            UserDb.getUser(comment.userId)?.name.toUpperCase() ?? 'USER',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(reply.text, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.2),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: (){
                context.read<PostBloc>().addCommentEvent(comment: _commentController.text, postId: post!.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getUserInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  String _formatDateTime(DateTime time) => '${time.day}/${time.month}/${time.year}';

  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => GoRouter.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<PostBloc>().deletePostEvent(postId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}