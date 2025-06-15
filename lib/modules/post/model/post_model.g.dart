
part of 'post_model.dart';

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 1;

  @override
  PostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as RichTextContent,
      body: fields[3] as RichTextContent,
      media: (fields[4] as List).cast<MediaModel>(),
      comments: (fields[5] as List).cast<CommentModel>(),
      likes: (fields[6] as List).cast<LikeModel>(),
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.media)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.likes)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LikeModelAdapter extends TypeAdapter<LikeModel> {
  @override
  final int typeId = 5;

  @override
  LikeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeModel(
      userId: fields[0] as String,
      likedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LikeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.likedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaModelAdapter extends TypeAdapter<MediaModel> {
  @override
  final int typeId = 2;

  @override
  MediaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MediaModel(url: fields[0] as String, type: fields[1] as MediaType);
  }

  @override
  void write(BinaryWriter writer, MediaModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MediaTypeAdapter extends TypeAdapter<MediaType> {
  @override
  final int typeId = 3;

  @override
  MediaType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MediaType.image;
      case 1:
        return MediaType.video;
      default:
        return MediaType.image;
    }
  }

  @override
  void write(BinaryWriter writer, MediaType obj) {
    switch (obj) {
      case MediaType.image:
        writer.writeByte(0);
        break;
      case MediaType.video:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentModelAdapter extends TypeAdapter<CommentModel> {
  @override
  final int typeId = 4;

  @override
  CommentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommentModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      text: fields[2] as String,
      createdAt: fields[3] as DateTime,
      replies: (fields[4] as List).cast<CommentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CommentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.replies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RichTextContentAdapter extends TypeAdapter<RichTextContent> {
  @override
  final int typeId = 10;

  @override
  RichTextContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RichTextContent(
      plainText: fields[0] as String,
      segments: (fields[1] as List).cast<TextSegment>(),
    );
  }

  @override
  void write(BinaryWriter writer, RichTextContent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.plainText)
      ..writeByte(1)
      ..write(obj.segments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RichTextContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TextSegmentAdapter extends TypeAdapter<TextSegment> {
  @override
  final int typeId = 11;

  @override
  TextSegment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextSegment(
      text: fields[0] as String,
      start: fields[1] as int,
      end: fields[2] as int,
      formatting: fields[3] as TextFormatting,
    );
  }

  @override
  void write(BinaryWriter writer, TextSegment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.formatting);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextSegmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TextFormattingAdapter extends TypeAdapter<TextFormatting> {
  @override
  final int typeId = 12;

  @override
  TextFormatting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextFormatting(
      isBold: fields[0] as bool,
      isItalic: fields[1] as bool,
      isUnderline: fields[2] as bool,
      fontSize: fields[3] as double,
      fontFamily: fields[4] as String,
      colorValue: fields[5] as int,
      backgroundColorValue: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TextFormatting obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isBold)
      ..writeByte(1)
      ..write(obj.isItalic)
      ..writeByte(2)
      ..write(obj.isUnderline)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.fontFamily)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.backgroundColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextFormattingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
