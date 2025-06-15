import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' hide DialogType;
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/main_feed/ui/update_profile_pic_dialog.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/post/ui/post_card.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen>
    with TickerProviderStateMixin {
  late UserModel? currentUser;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    currentUser = UserDb.getCurrentUser();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Widget _buildUserAvatar(ThemeData theme, {bool inverse = false}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors:inverse ? [
            Colors.white,
            Colors.white.withValues(alpha: 0.7),
          ] : [
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
      child: BlocBuilder<AuthBloc,AuthState>(
        builder: (context,state) {
          return CircleAvatar(
            radius: 18,
            backgroundColor: Colors.transparent,
            child: currentUser?.profilePath != null
                ? ClipOval(
                    child: Image.file(
                      File(currentUser!.profilePath!),
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildDefaultAvatar(theme,inverse),
                    ),
                  )
                : _buildDefaultAvatar(theme,inverse),
          );
        },
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme,bool inverse) {
    return Text(
      currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
      style: theme.textTheme.titleMedium?.copyWith(
        color:inverse ? theme.colorScheme.primary : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.post_add_rounded,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Posts Yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share something with the community!',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(ThemeData theme) {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.createPost);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 6,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          'Post',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static const darkStatusBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // or your dark color if needed
    statusBarIconBrightness: Brightness.light, // Android
    statusBarBrightness: Brightness.dark, // iOS
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: darkStatusBar,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        floatingActionButton: _buildFAB(theme),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chat_bubble_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Social App',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: PopupMenuButton(
                icon: _buildUserAvatar(theme,inverse: true),
                offset: const Offset(0, 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(

                    onTap: () {showUpdateProfilePicDialog(context,currentUser?.profilePath);

                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          _buildUserAvatar(theme),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back!',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentUser?.name ?? 'User',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const PopupMenuDivider(indent: 16, endIndent: 16, height: 1),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: theme.colorScheme.error,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sign Out',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.read<AuthBloc>().logoutEvent();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state) {
              case LogOutSuccess():
                context.go(AppRouter.login);
                toast(state.message);
              case PofilePicUpdated():
                currentUser = UserDb.getCurrentUser();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                GoRouter.of(context).pop();
              default:
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().fetchPostsEvent();
            },
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surface,
            child: SafeArea(
              child: BlocConsumer<PostBloc, PostState>(
                listener: (context, state) {
                  switch (state) {
                    case PostDeleted():
                      if(GoRouter.of(context).canPop()){
                      GoRouter.of(context).pop();}
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
                        ),
                      );
                    default:
                  }
                },
                builder: (context, state) {
                  if (state.store.postList.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: state.store.postList.length,
                    itemBuilder: (context, index) {
                      final post = state.store.postList[index];
                      return PostCard(
                        post: post,
                        isLiked: post.likes.any(
                          (like) => like.userId == UserDb.getCurrentUser()?.id,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
