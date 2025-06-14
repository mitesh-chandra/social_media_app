part of 'post_model.dart';

@HiveType(typeId: 5)
class LikeModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final DateTime likedAt;

  LikeModel({
    required this.userId,
    required this.likedAt,
  });
}
