part of 'post_bloc.dart';

@freezed
sealed class PostStore with _$PostStore {
  const factory PostStore({
    @Default(false) bool isLoading,
    @Default(false) bool isProcessingMedia,
    @Default(null) RichTextContent? title,
    @Default(null) RichTextContent? body,
    @Default([]) List<MediaModel> selectedMedia,
    @Default([]) List<PostModel> postList,
    @Default(null) String? replyingToCommentId,
    @Default(null) String? replyingToUser,
  }) = _PostStore;
}
