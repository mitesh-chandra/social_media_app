part of 'post_model.dart';

@HiveType(typeId: 2)
class MediaModel {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final MediaType type;

  MediaModel({required this.url, required this.type});
}

@HiveType(typeId: 3)
enum MediaType {
  @HiveField(0)
  image,

  @HiveField(1)
  video,
}
