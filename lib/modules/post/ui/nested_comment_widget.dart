import 'package:flutter/material.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/user/db/user_db.dart'; // Add this

class NestedCommentWidget extends StatelessWidget {
  final CommentModel comment;
  final int depth;
  final void Function(String parentId,String userName)? onReply;

  const NestedCommentWidget({
    super.key,
    required this.comment,
    this.depth = 0,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final user = UserDb.getUser(comment.userId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(12),
            color: isDark ? Colors.grey[900] : Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user?.name ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formattedTime(comment.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[200] : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => onReply?.call(comment.id,user?.name.toUpperCase() ?? 'USER'),
                    child: const Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...comment.replies.map(
                (reply) => NestedCommentWidget(
              comment: reply,
              depth: depth + 1,
              onReply: onReply,
            ),
          ),
        ],
      ),
    );
  }

  String _formattedTime(DateTime? time) {
    if (time == null) return '';
    final duration = DateTime.now().difference(time);
    if (duration.inMinutes < 1) return 'Just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    return '${duration.inDays}d ago';
  }
}
