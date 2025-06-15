part of 'post_model.dart';

@HiveType(typeId: 10)
class RichTextContent extends HiveObject {
  @HiveField(0)
  final String plainText; // For search and backup

  @HiveField(1)
  final List<TextSegment> segments; // Formatted segments

  RichTextContent({
    required this.plainText,
    required this.segments,
  });

  RichTextContent.fromPlainText(String text)
      : plainText = text,
        segments = [
          TextSegment(
            text: text,
            start: 0,
            end: text.length,
            formatting: TextFormatting(),
          )
        ];
  TextSpan toTextSpan() {
    if (segments.isEmpty) {
      return TextSpan(text: plainText);
    }

    final List<TextSpan> spans = [];
    for (final segment in segments) {
      spans.add(TextSpan(
        text: segment.text,
        style: segment.formatting.toTextStyle(),
      ));
    }

    return TextSpan(children: spans);
  }
  String get preview {
    if (plainText.length <= 150) return plainText;
    return '${plainText.substring(0, 150)}...';
  }
}

@HiveType(typeId: 11)
class TextSegment extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final int start;

  @HiveField(2)
  final int end;

  @HiveField(3)
  final TextFormatting formatting;

  TextSegment({
    required this.text,
    required this.start,
    required this.end,
    required this.formatting,
  });
}

@HiveType(typeId: 12)
class TextFormatting extends HiveObject {
  @HiveField(0)
  final bool isBold;

  @HiveField(1)
  final bool isItalic;

  @HiveField(2)
  final bool isUnderline;

  @HiveField(3)
  final double fontSize;

  @HiveField(4)
  final String fontFamily;

  @HiveField(5)
  final int colorValue; // Color as int (Color.value)

  @HiveField(6)
  final int backgroundColorValue; // Background color as int

  TextFormatting({
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.fontSize = 16.0,
    this.fontFamily = 'Roboto',
    this.colorValue = 0xFF000000, // Default black
    this.backgroundColorValue = 0x00000000, // Default transparent
  });

  Color get color => Color(colorValue);
  Color get backgroundColor => Color(backgroundColorValue);

  TextStyle toTextStyle() {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: color,
      backgroundColor: backgroundColor.a != 0 ? backgroundColor : null,
    );
  }

  TextFormatting copyWith({
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    double? fontSize,
    String? fontFamily,
    Color? color,
    Color? backgroundColor,
  }) {
    return TextFormatting(
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      colorValue: color?.value ?? colorValue,
      backgroundColorValue: backgroundColor?.value ?? backgroundColorValue,
    );
  }
}