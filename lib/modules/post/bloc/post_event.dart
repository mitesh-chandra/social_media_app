part of 'post_bloc.dart';

@freezed
sealed class PostEvent with _$PostEvent {
  const factory PostEvent.setPostTextEvent({
    String? title,
    String? body,
    List<MediaModel>? media,
  }) = _SetPostTextEvent;

  const factory PostEvent.createPostEvent() = _CreatePostEvent;

  const factory PostEvent.fetchPostsEvent() = _FetchPostsEvent;

  const factory PostEvent.deletePostEvent({
    required String postId,
  }) = _DeletePostEvent;

  const factory PostEvent.toggleLikeEvent({
    required bool isLiked,
    required String postId,
  }) = _ToggleLikeEvent;

  const factory PostEvent.addMediaEvent(List<MediaModel> mediaFiles) = _AddMediaEvent;

  const factory PostEvent.addCommentEvent({required String comment,required String postId, String? replyingToId}) = _AddCommentEvent;

  const factory PostEvent.removeMediaEvent({
    int? index,
    bool? removeAll,
    String? path,
  }) = _RemoveMediaEvent;

  const factory PostEvent.clearStoreEvent() = _ClearStoreEvent;
  const factory PostEvent.selectMediaEvent() = _SelectMediaEvent;
}
