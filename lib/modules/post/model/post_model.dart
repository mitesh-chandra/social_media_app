import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'post_model.g.dart';
part 'like_model.dart';
part 'media_model.dart';
part 'comment_model.dart';
part 'rich_text_model.dart';

@HiveType(typeId: 1)
class PostModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final RichTextContent title;

  @HiveField(3)
  final RichTextContent body; // Changed to RichTextContent

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
  String get plainText => body.plainText;
  String get preview => body.preview;
  bool get hasFormatting => body.segments.length > 1 ||
      body.segments.any((s) => s.formatting.isBold ||
          s.formatting.isItalic ||
          s.formatting.isUnderline ||
          s.formatting.fontSize != 16.0 ||
          s.formatting.colorValue != 0xFF000000);

  PostModel copyWith({
    String? id,
    String? userId,
    RichTextContent? title,
    RichTextContent? body,
    List<MediaModel>? media,
    List<CommentModel>? comments,
    List<LikeModel>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      media: media ?? this.media,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
