import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/auth/ui/login_screen.dart';
import 'package:social_media_app/modules/auth/ui/sign_up_screen.dart';
import 'package:social_media_app/modules/custom_gallery/ui/gallery_screen.dart';
import 'package:social_media_app/modules/main_feed/ui/main_feed_screen.dart';
import 'package:social_media_app/common_ui/error_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/post/ui/create_post_screen.dart';
import 'package:social_media_app/modules/post/ui/post_detail_page.dart';
import 'package:social_media_app/utils/media_preview.dart';

class AppRouter {
  static const mainFeed = '/';
  static const login = '/login';
  static const signUp = '/sign-up';
  static const createPost = '/create-post';
  static const viewMedia = '/view-media';
  static const galleryPage = '/gallery-page';
  static const postDetail = '/post-detail';
  static final GoRouter appRoutes = GoRouter(
    initialLocation: getBoolAsync(AppConstant.isLoggedIn) ? mainFeed : login,
    routes: [
      GoRoute(
        path: mainFeed,
        builder: (context, state) => const MainFeedScreen(),
      ),
      GoRoute(path: login, builder: (context, state) => LoginScreen()),
      GoRoute(path: signUp, builder: (context, state) => const SignUpScreen()),
      GoRoute(path: galleryPage, builder: (context, state) => const GalleryScreen()),
      GoRoute(path: postDetail, builder: (context, state) {
        final id = state.uri.queryParameters['postId']!;
        return PostDetailScreen(postId: id,);}),
      GoRoute(
        path: createPost,
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: viewMedia,
        builder: (context, state) {
          final index = int.parse(state.uri.queryParameters['index'] ?? '0');
          final mediaList = state.extra as List<MediaModel>;

          return MediaViewerScreen(
            initialIndex: index,
            mediaList: mediaList,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}
