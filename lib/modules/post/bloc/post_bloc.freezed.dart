// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostEvent()';
}


}

/// @nodoc
class $PostEventCopyWith<$Res>  {
$PostEventCopyWith(PostEvent _, $Res Function(PostEvent) __);
}


/// @nodoc


class _SetPostTextEvent implements PostEvent {
  const _SetPostTextEvent({this.title, this.body, final  List<MediaModel>? media}): _media = media;
  

 final  String? title;
 final  String? body;
 final  List<MediaModel>? _media;
 List<MediaModel>? get media {
  final value = _media;
  if (value == null) return null;
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetPostTextEventCopyWith<_SetPostTextEvent> get copyWith => __$SetPostTextEventCopyWithImpl<_SetPostTextEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetPostTextEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._media, _media));
}


@override
int get hashCode => Object.hash(runtimeType,title,body,const DeepCollectionEquality().hash(_media));

@override
String toString() {
  return 'PostEvent.setPostTextEvent(title: $title, body: $body, media: $media)';
}


}

/// @nodoc
abstract mixin class _$SetPostTextEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$SetPostTextEventCopyWith(_SetPostTextEvent value, $Res Function(_SetPostTextEvent) _then) = __$SetPostTextEventCopyWithImpl;
@useResult
$Res call({
 String? title, String? body, List<MediaModel>? media
});




}
/// @nodoc
class __$SetPostTextEventCopyWithImpl<$Res>
    implements _$SetPostTextEventCopyWith<$Res> {
  __$SetPostTextEventCopyWithImpl(this._self, this._then);

  final _SetPostTextEvent _self;
  final $Res Function(_SetPostTextEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? body = freezed,Object? media = freezed,}) {
  return _then(_SetPostTextEvent(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<MediaModel>?,
  ));
}


}

/// @nodoc


class _CreatePostEvent implements PostEvent {
  const _CreatePostEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePostEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostEvent.createPostEvent()';
}


}




/// @nodoc


class _FetchPostsEvent implements PostEvent {
  const _FetchPostsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchPostsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostEvent.fetchPostsEvent()';
}


}




/// @nodoc


class _DeletePostEvent implements PostEvent {
  const _DeletePostEvent({required this.postId});
  

 final  String postId;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletePostEventCopyWith<_DeletePostEvent> get copyWith => __$DeletePostEventCopyWithImpl<_DeletePostEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletePostEvent&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,postId);

@override
String toString() {
  return 'PostEvent.deletePostEvent(postId: $postId)';
}


}

/// @nodoc
abstract mixin class _$DeletePostEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$DeletePostEventCopyWith(_DeletePostEvent value, $Res Function(_DeletePostEvent) _then) = __$DeletePostEventCopyWithImpl;
@useResult
$Res call({
 String postId
});




}
/// @nodoc
class __$DeletePostEventCopyWithImpl<$Res>
    implements _$DeletePostEventCopyWith<$Res> {
  __$DeletePostEventCopyWithImpl(this._self, this._then);

  final _DeletePostEvent _self;
  final $Res Function(_DeletePostEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? postId = null,}) {
  return _then(_DeletePostEvent(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToggleLikeEvent implements PostEvent {
  const _ToggleLikeEvent({required this.isLiked, required this.postId});
  

 final  bool isLiked;
 final  String postId;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleLikeEventCopyWith<_ToggleLikeEvent> get copyWith => __$ToggleLikeEventCopyWithImpl<_ToggleLikeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleLikeEvent&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.postId, postId) || other.postId == postId));
}


@override
int get hashCode => Object.hash(runtimeType,isLiked,postId);

@override
String toString() {
  return 'PostEvent.toggleLikeEvent(isLiked: $isLiked, postId: $postId)';
}


}

/// @nodoc
abstract mixin class _$ToggleLikeEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$ToggleLikeEventCopyWith(_ToggleLikeEvent value, $Res Function(_ToggleLikeEvent) _then) = __$ToggleLikeEventCopyWithImpl;
@useResult
$Res call({
 bool isLiked, String postId
});




}
/// @nodoc
class __$ToggleLikeEventCopyWithImpl<$Res>
    implements _$ToggleLikeEventCopyWith<$Res> {
  __$ToggleLikeEventCopyWithImpl(this._self, this._then);

  final _ToggleLikeEvent _self;
  final $Res Function(_ToggleLikeEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isLiked = null,Object? postId = null,}) {
  return _then(_ToggleLikeEvent(
isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AddMediaEvent implements PostEvent {
  const _AddMediaEvent(final  List<MediaModel> mediaFiles): _mediaFiles = mediaFiles;
  

 final  List<MediaModel> _mediaFiles;
 List<MediaModel> get mediaFiles {
  if (_mediaFiles is EqualUnmodifiableListView) return _mediaFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaFiles);
}


/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddMediaEventCopyWith<_AddMediaEvent> get copyWith => __$AddMediaEventCopyWithImpl<_AddMediaEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddMediaEvent&&const DeepCollectionEquality().equals(other._mediaFiles, _mediaFiles));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mediaFiles));

@override
String toString() {
  return 'PostEvent.addMediaEvent(mediaFiles: $mediaFiles)';
}


}

/// @nodoc
abstract mixin class _$AddMediaEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$AddMediaEventCopyWith(_AddMediaEvent value, $Res Function(_AddMediaEvent) _then) = __$AddMediaEventCopyWithImpl;
@useResult
$Res call({
 List<MediaModel> mediaFiles
});




}
/// @nodoc
class __$AddMediaEventCopyWithImpl<$Res>
    implements _$AddMediaEventCopyWith<$Res> {
  __$AddMediaEventCopyWithImpl(this._self, this._then);

  final _AddMediaEvent _self;
  final $Res Function(_AddMediaEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mediaFiles = null,}) {
  return _then(_AddMediaEvent(
null == mediaFiles ? _self._mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<MediaModel>,
  ));
}


}

/// @nodoc


class _AddCommentEvent implements PostEvent {
  const _AddCommentEvent({required this.comment, required this.postId, this.replyingToId});
  

 final  String comment;
 final  String postId;
 final  String? replyingToId;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddCommentEventCopyWith<_AddCommentEvent> get copyWith => __$AddCommentEventCopyWithImpl<_AddCommentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddCommentEvent&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.replyingToId, replyingToId) || other.replyingToId == replyingToId));
}


@override
int get hashCode => Object.hash(runtimeType,comment,postId,replyingToId);

@override
String toString() {
  return 'PostEvent.addCommentEvent(comment: $comment, postId: $postId, replyingToId: $replyingToId)';
}


}

/// @nodoc
abstract mixin class _$AddCommentEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$AddCommentEventCopyWith(_AddCommentEvent value, $Res Function(_AddCommentEvent) _then) = __$AddCommentEventCopyWithImpl;
@useResult
$Res call({
 String comment, String postId, String? replyingToId
});




}
/// @nodoc
class __$AddCommentEventCopyWithImpl<$Res>
    implements _$AddCommentEventCopyWith<$Res> {
  __$AddCommentEventCopyWithImpl(this._self, this._then);

  final _AddCommentEvent _self;
  final $Res Function(_AddCommentEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? comment = null,Object? postId = null,Object? replyingToId = freezed,}) {
  return _then(_AddCommentEvent(
comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,replyingToId: freezed == replyingToId ? _self.replyingToId : replyingToId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _RemoveMediaEvent implements PostEvent {
  const _RemoveMediaEvent({this.index, this.removeAll, this.path});
  

 final  int? index;
 final  bool? removeAll;
 final  String? path;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveMediaEventCopyWith<_RemoveMediaEvent> get copyWith => __$RemoveMediaEventCopyWithImpl<_RemoveMediaEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveMediaEvent&&(identical(other.index, index) || other.index == index)&&(identical(other.removeAll, removeAll) || other.removeAll == removeAll)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,index,removeAll,path);

@override
String toString() {
  return 'PostEvent.removeMediaEvent(index: $index, removeAll: $removeAll, path: $path)';
}


}

/// @nodoc
abstract mixin class _$RemoveMediaEventCopyWith<$Res> implements $PostEventCopyWith<$Res> {
  factory _$RemoveMediaEventCopyWith(_RemoveMediaEvent value, $Res Function(_RemoveMediaEvent) _then) = __$RemoveMediaEventCopyWithImpl;
@useResult
$Res call({
 int? index, bool? removeAll, String? path
});




}
/// @nodoc
class __$RemoveMediaEventCopyWithImpl<$Res>
    implements _$RemoveMediaEventCopyWith<$Res> {
  __$RemoveMediaEventCopyWithImpl(this._self, this._then);

  final _RemoveMediaEvent _self;
  final $Res Function(_RemoveMediaEvent) _then;

/// Create a copy of PostEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? removeAll = freezed,Object? path = freezed,}) {
  return _then(_RemoveMediaEvent(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,removeAll: freezed == removeAll ? _self.removeAll : removeAll // ignore: cast_nullable_to_non_nullable
as bool?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _ClearStoreEvent implements PostEvent {
  const _ClearStoreEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearStoreEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostEvent.clearStoreEvent()';
}


}




/// @nodoc


class _SelectMediaEvent implements PostEvent {
  const _SelectMediaEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectMediaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PostEvent.selectMediaEvent()';
}


}




/// @nodoc
mixin _$PostState {

 PostStore get store;
/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStateCopyWith<PostState> get copyWith => _$PostStateCopyWithImpl<PostState>(this as PostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostState&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'PostState(store: $store)';
}


}

/// @nodoc
abstract mixin class $PostStateCopyWith<$Res>  {
  factory $PostStateCopyWith(PostState value, $Res Function(PostState) _then) = _$PostStateCopyWithImpl;
@useResult
$Res call({
 PostStore store
});


$PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$PostStateCopyWithImpl<$Res>
    implements $PostStateCopyWith<$Res> {
  _$PostStateCopyWithImpl(this._self, this._then);

  final PostState _self;
  final $Res Function(PostState) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? store = null,}) {
  return _then(_self.copyWith(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,
  ));
}
/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


/// @nodoc


class Initial implements PostState {
  const Initial({required this.store});
  

@override final  PostStore store;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialCopyWith<Initial> get copyWith => _$InitialCopyWithImpl<Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'PostState.initial(store: $store)';
}


}

/// @nodoc
abstract mixin class $InitialCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) _then) = _$InitialCopyWithImpl;
@override @useResult
$Res call({
 PostStore store
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$InitialCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(this._self, this._then);

  final Initial _self;
  final $Res Function(Initial) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,}) {
  return _then(Initial(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class General implements PostState {
  const General({required this.store});
  

@override final  PostStore store;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralCopyWith<General> get copyWith => _$GeneralCopyWithImpl<General>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is General&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'PostState.general(store: $store)';
}


}

/// @nodoc
abstract mixin class $GeneralCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $GeneralCopyWith(General value, $Res Function(General) _then) = _$GeneralCopyWithImpl;
@override @useResult
$Res call({
 PostStore store
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$GeneralCopyWithImpl<$Res>
    implements $GeneralCopyWith<$Res> {
  _$GeneralCopyWithImpl(this._self, this._then);

  final General _self;
  final $Res Function(General) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,}) {
  return _then(General(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class PostCreated implements PostState {
  const PostCreated({required this.store, required this.message});
  

@override final  PostStore store;
 final  String message;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCreatedCopyWith<PostCreated> get copyWith => _$PostCreatedCopyWithImpl<PostCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostCreated&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'PostState.postCreated(store: $store, message: $message)';
}


}

/// @nodoc
abstract mixin class $PostCreatedCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $PostCreatedCopyWith(PostCreated value, $Res Function(PostCreated) _then) = _$PostCreatedCopyWithImpl;
@override @useResult
$Res call({
 PostStore store, String message
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$PostCreatedCopyWithImpl<$Res>
    implements $PostCreatedCopyWith<$Res> {
  _$PostCreatedCopyWithImpl(this._self, this._then);

  final PostCreated _self;
  final $Res Function(PostCreated) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(PostCreated(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class PostListUpdated implements PostState {
  const PostListUpdated({required this.store});
  

@override final  PostStore store;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostListUpdatedCopyWith<PostListUpdated> get copyWith => _$PostListUpdatedCopyWithImpl<PostListUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostListUpdated&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'PostState.postListUpdated(store: $store)';
}


}

/// @nodoc
abstract mixin class $PostListUpdatedCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $PostListUpdatedCopyWith(PostListUpdated value, $Res Function(PostListUpdated) _then) = _$PostListUpdatedCopyWithImpl;
@override @useResult
$Res call({
 PostStore store
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$PostListUpdatedCopyWithImpl<$Res>
    implements $PostListUpdatedCopyWith<$Res> {
  _$PostListUpdatedCopyWithImpl(this._self, this._then);

  final PostListUpdated _self;
  final $Res Function(PostListUpdated) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,}) {
  return _then(PostListUpdated(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class LikeToggled implements PostState {
  const LikeToggled({required this.store, required this.id});
  

@override final  PostStore store;
 final  String id;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeToggledCopyWith<LikeToggled> get copyWith => _$LikeToggledCopyWithImpl<LikeToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeToggled&&(identical(other.store, store) || other.store == store)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,store,id);

@override
String toString() {
  return 'PostState.likeToggled(store: $store, id: $id)';
}


}

/// @nodoc
abstract mixin class $LikeToggledCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $LikeToggledCopyWith(LikeToggled value, $Res Function(LikeToggled) _then) = _$LikeToggledCopyWithImpl;
@override @useResult
$Res call({
 PostStore store, String id
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$LikeToggledCopyWithImpl<$Res>
    implements $LikeToggledCopyWith<$Res> {
  _$LikeToggledCopyWithImpl(this._self, this._then);

  final LikeToggled _self;
  final $Res Function(LikeToggled) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? id = null,}) {
  return _then(LikeToggled(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class PostDeleted implements PostState {
  const PostDeleted({required this.store, required this.message});
  

@override final  PostStore store;
 final  String message;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDeletedCopyWith<PostDeleted> get copyWith => _$PostDeletedCopyWithImpl<PostDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostDeleted&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'PostState.postDeleted(store: $store, message: $message)';
}


}

/// @nodoc
abstract mixin class $PostDeletedCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $PostDeletedCopyWith(PostDeleted value, $Res Function(PostDeleted) _then) = _$PostDeletedCopyWithImpl;
@override @useResult
$Res call({
 PostStore store, String message
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$PostDeletedCopyWithImpl<$Res>
    implements $PostDeletedCopyWith<$Res> {
  _$PostDeletedCopyWithImpl(this._self, this._then);

  final PostDeleted _self;
  final $Res Function(PostDeleted) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(PostDeleted(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc


class PostError implements PostState {
  const PostError({required this.store, required this.error});
  

@override final  PostStore store;
 final  String error;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostErrorCopyWith<PostError> get copyWith => _$PostErrorCopyWithImpl<PostError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostError&&(identical(other.store, store) || other.store == store)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,store,error);

@override
String toString() {
  return 'PostState.postError(store: $store, error: $error)';
}


}

/// @nodoc
abstract mixin class $PostErrorCopyWith<$Res> implements $PostStateCopyWith<$Res> {
  factory $PostErrorCopyWith(PostError value, $Res Function(PostError) _then) = _$PostErrorCopyWithImpl;
@override @useResult
$Res call({
 PostStore store, String error
});


@override $PostStoreCopyWith<$Res> get store;

}
/// @nodoc
class _$PostErrorCopyWithImpl<$Res>
    implements $PostErrorCopyWith<$Res> {
  _$PostErrorCopyWithImpl(this._self, this._then);

  final PostError _self;
  final $Res Function(PostError) _then;

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? error = null,}) {
  return _then(PostError(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as PostStore,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PostState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostStoreCopyWith<$Res> get store {
  
  return $PostStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}

/// @nodoc
mixin _$PostStore {

 bool get isLoading; bool get isProcessingMedia; String get title; String get body; List<MediaModel> get selectedMedia; List<PostModel> get postList;
/// Create a copy of PostStore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostStoreCopyWith<PostStore> get copyWith => _$PostStoreCopyWithImpl<PostStore>(this as PostStore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostStore&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isProcessingMedia, isProcessingMedia) || other.isProcessingMedia == isProcessingMedia)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.selectedMedia, selectedMedia)&&const DeepCollectionEquality().equals(other.postList, postList));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isProcessingMedia,title,body,const DeepCollectionEquality().hash(selectedMedia),const DeepCollectionEquality().hash(postList));

@override
String toString() {
  return 'PostStore(isLoading: $isLoading, isProcessingMedia: $isProcessingMedia, title: $title, body: $body, selectedMedia: $selectedMedia, postList: $postList)';
}


}

/// @nodoc
abstract mixin class $PostStoreCopyWith<$Res>  {
  factory $PostStoreCopyWith(PostStore value, $Res Function(PostStore) _then) = _$PostStoreCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isProcessingMedia, String title, String body, List<MediaModel> selectedMedia, List<PostModel> postList
});




}
/// @nodoc
class _$PostStoreCopyWithImpl<$Res>
    implements $PostStoreCopyWith<$Res> {
  _$PostStoreCopyWithImpl(this._self, this._then);

  final PostStore _self;
  final $Res Function(PostStore) _then;

/// Create a copy of PostStore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isProcessingMedia = null,Object? title = null,Object? body = null,Object? selectedMedia = null,Object? postList = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isProcessingMedia: null == isProcessingMedia ? _self.isProcessingMedia : isProcessingMedia // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,selectedMedia: null == selectedMedia ? _self.selectedMedia : selectedMedia // ignore: cast_nullable_to_non_nullable
as List<MediaModel>,postList: null == postList ? _self.postList : postList // ignore: cast_nullable_to_non_nullable
as List<PostModel>,
  ));
}

}


/// @nodoc


class _PostStore implements PostStore {
  const _PostStore({this.isLoading = false, this.isProcessingMedia = false, this.title = '', this.body = '', final  List<MediaModel> selectedMedia = const [], final  List<PostModel> postList = const []}): _selectedMedia = selectedMedia,_postList = postList;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isProcessingMedia;
@override@JsonKey() final  String title;
@override@JsonKey() final  String body;
 final  List<MediaModel> _selectedMedia;
@override@JsonKey() List<MediaModel> get selectedMedia {
  if (_selectedMedia is EqualUnmodifiableListView) return _selectedMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedMedia);
}

 final  List<PostModel> _postList;
@override@JsonKey() List<PostModel> get postList {
  if (_postList is EqualUnmodifiableListView) return _postList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_postList);
}


/// Create a copy of PostStore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostStoreCopyWith<_PostStore> get copyWith => __$PostStoreCopyWithImpl<_PostStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostStore&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isProcessingMedia, isProcessingMedia) || other.isProcessingMedia == isProcessingMedia)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._selectedMedia, _selectedMedia)&&const DeepCollectionEquality().equals(other._postList, _postList));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isProcessingMedia,title,body,const DeepCollectionEquality().hash(_selectedMedia),const DeepCollectionEquality().hash(_postList));

@override
String toString() {
  return 'PostStore(isLoading: $isLoading, isProcessingMedia: $isProcessingMedia, title: $title, body: $body, selectedMedia: $selectedMedia, postList: $postList)';
}


}

/// @nodoc
abstract mixin class _$PostStoreCopyWith<$Res> implements $PostStoreCopyWith<$Res> {
  factory _$PostStoreCopyWith(_PostStore value, $Res Function(_PostStore) _then) = __$PostStoreCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isProcessingMedia, String title, String body, List<MediaModel> selectedMedia, List<PostModel> postList
});




}
/// @nodoc
class __$PostStoreCopyWithImpl<$Res>
    implements _$PostStoreCopyWith<$Res> {
  __$PostStoreCopyWithImpl(this._self, this._then);

  final _PostStore _self;
  final $Res Function(_PostStore) _then;

/// Create a copy of PostStore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isProcessingMedia = null,Object? title = null,Object? body = null,Object? selectedMedia = null,Object? postList = null,}) {
  return _then(_PostStore(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isProcessingMedia: null == isProcessingMedia ? _self.isProcessingMedia : isProcessingMedia // ignore: cast_nullable_to_non_nullable
as bool,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,selectedMedia: null == selectedMedia ? _self._selectedMedia : selectedMedia // ignore: cast_nullable_to_non_nullable
as List<MediaModel>,postList: null == postList ? _self._postList : postList // ignore: cast_nullable_to_non_nullable
as List<PostModel>,
  ));
}


}

// dart format on
