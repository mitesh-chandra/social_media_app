import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/post/db/post_db.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:uuid/uuid.dart';

part 'post_event.dart';
part 'post_state.dart';
part 'post_store.dart';
part 'post_bloc.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostState.initial(store: PostStore(postList: PostDb.getAllPosts()))) {
    on<_SetPostTextEvent>(_onSetPostTextEvent);
    on<_CreatePostEvent>(_onCreatePostEvent);
    on<_FetchPostsEvent>(_onFetchPostsEvent);
    on<_DeletePostEvent>(_onDeletePostEvent);
    on<_AddMediaEvent>(_onAddMediaEvent);
    on<_RemoveMediaEvent>(_onRemoveMediaEvent);
    on<_SelectMediaEvent>(_onSelectMediaEvent);
    on<_ToggleLikeEvent>(_onToggleLikeEvent);
    on<_AddCommentEvent>(_onAddCommentEvent);
    on<_ClearStoreEvent>(_onClearStoreEvent);
    on<_ReplyToCommentEvent>(_onReplyToCommentEvent);
  }

  Future<void> _onSetPostTextEvent(
      _SetPostTextEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(
      PostState.general(
        store: state.store.copyWith(
          title: event.title ?? state.store.title,
          body: event.body ?? state.store.body,
          selectedMedia: event.media ?? state.store.selectedMedia,
        ),
      ),
    );
  }

  Future<void> _onCreatePostEvent(
      _CreatePostEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isLoading: true)));
    try {
      final id = const Uuid().v4();
      final post = PostModel(
        id: id,
        userId: getStringAsync(AppConstant.userId),
        title: state.store.title,
        body: state.store.body,
        media: state.store.selectedMedia,
        comments: [],
        likes: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await PostDb.addPost(post);
      emit(
        PostState.postCreated(
          store: state.store.copyWith(
            isLoading: false,
            title: '',
            body: '',
            selectedMedia: [],
            postList: PostDb.getAllPosts()
          ),
          message: 'Post created successfully!',
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        PostState.postError(
          store: state.store.copyWith(isLoading: false),
          error: 'Failed to create post.',
        ),
      );
    }
  }

  Future<void> _onFetchPostsEvent(
      _FetchPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isLoading: true)));
    try {
      final posts = PostDb.getAllPosts();
      emit(
        PostState.postListUpdated(
          store: state.store.copyWith(
            isLoading: false,
            postList: posts,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(
        PostState.postError(
          store: state.store.copyWith(isLoading: false),
          error: 'Unable to fetch posts.',
        ),
      );
    }
  }

  Future<void> _onDeletePostEvent(
      _DeletePostEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isLoading: true)));
    try {
      await PostDb.deletePost(event.postId);
      emit(PostState.postDeleted(store: state.store.copyWith(postList: PostDb.getAllPosts(),isLoading: false), message: 'Post deleted.'));
    } catch (e) {
      debugPrint(e.toString());
      emit(
        PostState.postError(
          store: state.store.copyWith(isLoading: false),
          error: 'Unable to delete post.',
        ),
      );
    }
  }


  Future<void> _onAddMediaEvent(_AddMediaEvent event, Emitter<PostState> emit,) async{
    final updatedList = List<MediaModel>.from(state.store.selectedMedia)..addAll(event.mediaFiles);
    emit(PostState.general(store: state.store.copyWith(selectedMedia: updatedList)));
  }


  Future<void> _onRemoveMediaEvent(_RemoveMediaEvent event, Emitter<PostState> emit,) async{
    List<MediaModel> updated = List.from(state.store.selectedMedia);

    if (event.removeAll ?? false) {
      updated.clear();
    } else if (event.path != null) {
      updated.removeWhere((media) => media.url == event.path);
    } else if (event.index != null && event.index! < updated.length) {
      updated.removeAt(event.index!);
    }

    emit(PostState.general(store: state.store.copyWith(selectedMedia: updated)));
  }

  void _onSelectMediaEvent(
      _SelectMediaEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isProcessingMedia: true)));

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
      );

      if (result == null) {
        emit(PostState.general(store: state.store.copyWith(isProcessingMedia: false)));
        return;
      }

      final pickedFiles = result.files.map((file) {
        final extension = file.extension?.toLowerCase();
        final isVideo = ['mp4', 'mov', 'avi'].contains(extension);
        return MediaModel(
          url: file.path!,
          type: isVideo ? MediaType.video : MediaType.image,
        );
      }).toList();

      add(PostEvent.addMediaEvent(pickedFiles));
    } catch (e) {
      emit(PostState.general(store: state.store.copyWith(isProcessingMedia: false)));
    }
  }

  void _onToggleLikeEvent(
      _ToggleLikeEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isLoading: true)));

    try {
      if(event.isLiked){
      PostDb.addLike(event.postId, getStringAsync(AppConstant.userId));}else{
        PostDb.removeLike(event.postId, getStringAsync(AppConstant.userId));
      }

      emit(PostState.likeToggled(store: state.store.copyWith(isLoading: false,postList: PostDb.getAllPosts()),id: event.postId));
    } catch (e) {
      emit(PostState.postError(store: state.store.copyWith(isLoading: false),error: 'Something went wrong. Please try later.'));
    }
  }

  void _onAddCommentEvent(
      _AddCommentEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(isLoading: true)));

    try {
      final id = const Uuid().v4();
      final comment = CommentModel(id: id, userId: getStringAsync(AppConstant.userId), text: event.comment, createdAt: DateTime.now(), replies: []);
        PostDb.addComment(event.postId, comment,parentCommentId: state.store.replyingToCommentId);
      emit(PostState.commentAdded(store: state.store.copyWith(isLoading: false,postList: PostDb.getAllPosts()),));
    } catch (e) {
      emit(PostState.postError(store: state.store.copyWith(isLoading: false),error: 'Something went wrong. Please try later.'));
    }
  }

  void _onClearStoreEvent(
      _ClearStoreEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(
      title: '',
      body: '',
      selectedMedia: [],
    )));
  }

  void _onReplyToCommentEvent(
      _ReplyToCommentEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostState.general(store: state.store.copyWith(
        replyingToCommentId:event.id,
      replyingToUser:event.userName,
    )));
  }


  // Exposed functions
  void createPostEvent() => add(const PostEvent.createPostEvent());
  void fetchPostsEvent() => add(const PostEvent.fetchPostsEvent());
  void deletePostEvent(String postId) => add(PostEvent.deletePostEvent(postId: postId));
  void clearStoreEvent() => add(const PostEvent.clearStoreEvent());
  void selectMediaEvent() => add(const PostEvent.selectMediaEvent());
  void addCommentEvent({required String comment,required String postId, String? replyingToId}) => add(PostEvent.addCommentEvent(comment: comment,postId: postId,replyingToId: replyingToId));
  void toggleLikeEvent({
    required bool isLiked,
    required String postId,
  }) => add(PostEvent.toggleLikeEvent(isLiked: isLiked, postId: postId));
  void addMediaEvent(List<MediaModel> mediaFiles) => add(PostEvent.addMediaEvent(mediaFiles));
  void removeMediaEvent({
    int? index,
    bool? removeAll,
    String? path,
  }) => add(PostEvent.removeMediaEvent(path: path,removeAll: removeAll,index: index));

  void setPostTextEvent({
    String? title,
    String? body,
    List<MediaModel>? media,
  }) {
    add(PostEvent.setPostTextEvent(title: title, body: body, media: media));
  }
  void replyToCommentEvent(String? id,String? userName,) => add(PostEvent.replyToCommentEvent(id,userName));
}
