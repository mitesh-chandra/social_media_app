import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/post/ui/text_formater.dart';
import 'package:social_media_app/utils/message_dialog.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Widget _buildPostButton(PostState state, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: state.store.isLoading
            ? null
            : LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: state.store.isLoading
            ? null
            : [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: state.store.isLoading
            ? null
            : () {
          if (_formKey.currentState?.validate() ?? false) {
            context.read<PostBloc>().createPostEvent();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: state.store.isLoading
              ? theme.colorScheme.surface
              : Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: state.store.isLoading
            ? SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.send_rounded,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Post',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField(PostStore store, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.title_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Title',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormatter(
              controller: _titleController,
              maxLines: 3,
              hintText: "What would you like to share?",
              showToolbar: true,
              baseTextStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              onContentChanged: (content) {
                context.read<PostBloc>().setPostTextEvent(title: content);
              },
              validator: (text) => text?.trim().isNotEmpty == true
                  ? null
                  : 'Please enter a title for your post',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyField(PostStore store, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.edit_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Content',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormatter(
              controller: _bodyController,
              maxLines: 10,
              hintText: "Share your thoughts, experiences, or ask a question...",
              showToolbar: true,
              baseTextStyle: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface,
              ),
              onContentChanged: (content) {
                context.read<PostBloc>().setPostTextEvent(body: content);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(PostStore store, ThemeData theme) {
    final hasMedia = store.selectedMedia.isNotEmpty;
    final isProcessing = store.isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.attachment_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Media',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (hasMedia)
                Text(
                  '${store.selectedMedia.length} ${store.selectedMedia.length == 1 ? 'file' : 'files'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),

          if (hasMedia) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: store.selectedMedia.length,
                itemBuilder: (context, index) {
                  final media = store.selectedMedia[index];
                  return media.type == MediaType.image
                      ? _buildImagePreview(media.url, index, theme)
                      : _buildVideoPreview(media.url, index, theme);
                },
              ),
            ),
          ],

          if (isProcessing) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Processing media...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: isProcessing
                          ? null
                          : () async {
                        final mediaList = await GoRouter.of(context)
                            .push<List<MediaModel>>(AppRouter.galleryPage);
                        if (mediaList != null) {
                          context.read<PostBloc>().addMediaEvent(mediaList);
                        }
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 18,
                        color: isProcessing
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                            : theme.colorScheme.primary,
                      ),
                      label: Text(
                        hasMedia ? 'Add More' : 'Add Photos/Videos',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (hasMedia) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isProcessing
                            ? null
                            : () => context.read<PostBloc>().removeMediaEvent(removeAll: true),
                        icon: Icon(
                          Icons.clear_all_rounded,
                          size: 18,
                          color: isProcessing
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                              : theme.colorScheme.error,
                        ),
                        label: Text(
                          'Clear All',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isProcessing
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                                : theme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isProcessing
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                                : theme.colorScheme.error,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isProcessing
                            ? null
                            : () async {
                          final mediaList = await GoRouter.of(context)
                              .push<List<MediaModel>>(AppRouter.galleryPage);
                          if (mediaList != null) {
                            context.read<PostBloc>().addMediaEvent(mediaList);
                          }
                        },
                        icon: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 18,
                          color: isProcessing
                              ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                              : theme.colorScheme.primary,
                        ),
                        label: Text(
                          hasMedia ? 'Add More' : 'Add Photos/Videos',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    if (hasMedia) ...[
                      const SizedBox(width: 12),
                      Flexible(
                        child: OutlinedButton.icon(
                          onPressed: isProcessing
                              ? null
                              : () => context.read<PostBloc>().removeMediaEvent(removeAll: true),
                          icon: Icon(
                            Icons.clear_all_rounded,
                            size: 18,
                            color: isProcessing
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                                : theme.colorScheme.error,
                          ),
                          label: Text(
                            'Clear All',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isProcessing
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                                  : theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isProcessing
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                                  : theme.colorScheme.error,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String path, int index, ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(path),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => context.read<PostBloc>().removeMediaEvent(index: index),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onError,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview(String path, int index, ThemeData theme) {
    return FutureBuilder<Uint8List?>(
      future: VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 75,
      ),
      builder: (context, snapshot) {
        final thumbnail = snapshot.data;
        print(thumbnail);

        return Container(
          width: 120,
          height: 120,
          margin: const EdgeInsets.only(right: 12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  image: thumbnail != null
                      ? DecorationImage(
                    image: MemoryImage(thumbnail),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: thumbnail == null
                    ? Center(
                  child: Icon(
                    Icons.videocam_rounded,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                )
                    : null,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => context.read<PostBloc>().removeMediaEvent(index: index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: theme.colorScheme.onError,
                      size: 14,
                    ),
                  ),
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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<PostBloc>().clearStoreEvent();
        }
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
                  Icons.create_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Create Post',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return _buildPostButton(state, theme);
              },
            ),
          ],
        ),
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            switch (state) {
              case PostCreated():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(state.message),
                      ],
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
                context.pop();
              case PostError():
                showMessageDialog(context: context, message: state.error);
              default:
            }
          },
          builder: (context, state) {
            final store = state.store;

            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTitleField(store, theme),

                          const SizedBox(height: 16),
                          _buildBodyField(store, theme),

                          const SizedBox(height: 16),
                          _buildMediaSection(store, theme),
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}