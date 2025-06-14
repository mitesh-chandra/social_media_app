part of 'post_model.dart';

@HiveType(typeId: 4)
class CommentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.replies,
  });
}
