import 'package:hive/hive.dart';

part 'post_model.g.dart';
part 'like_model.dart';
part 'media_model.dart';
part 'comment_model.dart';

@HiveType(typeId: 1)
class PostModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  @HiveField(4)
  final List<MediaModel> media;

  @HiveField(5)
  final List<CommentModel> comments;

  @HiveField(6)
  final List<LikeModel> likes;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.media,
    required this.comments,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  int get likeCount => likes.length;

  int get commentCount => countAllComments(comments);

  int countAllComments(List<CommentModel> list) {
    int count = 0;
    for (final c in list) {
      count++;
      count += countAllComments(c.replies);
    }
    return count;
  }

}
