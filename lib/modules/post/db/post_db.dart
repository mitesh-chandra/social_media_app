import 'package:hive/hive.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';

class PostDb {
  static final Box<PostModel> _postBox = Hive.box<PostModel>(AppConstant.postDb);
  static Future<void> addPost(PostModel post) async {
    await _postBox.put(post.id, post);
  }
  static PostModel? getPost(String id) {
    return _postBox.get(id);
  }
  static List<PostModel> getAllPosts() {
    return _postBox.values.toList();
  }
  static Future<void> deletePost(String id) async {
    await _postBox.delete(id);
  }
  static Future<void> clearAll() async {
    await _postBox.clear();
  }
  static List<PostModel> getPostsByUser(String userId) {
    return _postBox.values.where((post) => post.userId == userId).toList();
  }
  static Future<void> addLike(String postId, String userId) async {
    final post = getPost(postId);
    if (post == null) return;

    final alreadyLiked = post.likes.any((like) => like.userId == userId);
    if (!alreadyLiked) {
      post.likes.add(LikeModel(userId: userId, likedAt: DateTime.now()));
      await addPost(post);
    }
  }
  static Future<void> removeLike(String postId, String userId) async {
    final post = getPost(postId);
    if (post == null) return;

    post.likes.removeWhere((like) => like.userId == userId);
    await addPost(post);
  }
  static Future<void> addComment(String postId, CommentModel comment, {String? parentCommentId}) async {
    final post = getPost(postId);
    if (post == null) return;

    if (parentCommentId == null) {
      post.comments.add(comment);
    } else {
      _addReplyToComment(post.comments, parentCommentId, comment);
    }

    await addPost(post);
  }

  static void _addReplyToComment(List<CommentModel> comments, String parentId, CommentModel reply) {
    for (final comment in comments) {
      if (comment.id == parentId) {
        comment.replies.add(reply);
        return;
      } else {
        _addReplyToComment(comment.replies, parentId, reply);
      }
    }
  }
}
