part of 'post_bloc.dart';

@freezed
sealed class PostState with _$PostState {
  const factory PostState.initial({required PostStore store}) = Initial;
  const factory PostState.general({required PostStore store}) = General;

  const factory PostState.postCreated({
    required PostStore store,
    required String message,
  }) = PostCreated;

  const factory PostState.postListUpdated({
    required PostStore store,
  }) = PostListUpdated;

  const factory PostState.likeToggled({
    required PostStore store,
    required String id,
  }) = LikeToggled;

  const factory PostState.postDeleted({
    required PostStore store,
    required String message,
  }) = PostDeleted;

  const factory PostState.postError({
    required PostStore store,
    required String error,
  }) = PostError;
}
