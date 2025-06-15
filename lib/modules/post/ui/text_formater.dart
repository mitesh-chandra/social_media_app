import 'package:flutter/material.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';

class TextFormatter extends StatefulWidget {
  final TextEditingController controller;
  final Function(RichTextContent) onContentChanged;
  final String? hintText;
  final bool showToolbar;
  final int? maxLines;
  final TextStyle? baseTextStyle;
  final String? Function(String?)? validator;

  const TextFormatter({
    super.key,
    required this.controller,
    required this.onContentChanged,
    this.hintText,
    this.showToolbar = true,
    this.maxLines,
    this.baseTextStyle,
    this.validator,
  });

  @override
  State<TextFormatter> createState() => _TextFormatterState();
}

class _TextFormatterState extends State<TextFormatter> {
  double fontSize = 16.0;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;
  FontStyle fontStyle = FontStyle.normal;
  Color textColor = Colors.black;
  String fontFamily = 'Roboto';
  final List<double> fontSizes = [10, 12, 14, 16, 18, 20, 22, 24, 28, 32, 36, 40];
  final List<String> fontFamilies = ['Roboto', 'Arial', 'Times New Roman', 'Courier New', 'Helvetica'];
  final List<Color> colors = [
    Colors.black, Colors.red, Colors.blue, Colors.green,
    Colors.orange, Colors.purple, Colors.brown, Colors.pink,
    Colors.indigo, Colors.teal, Colors.amber, Colors.cyan,
    Colors.grey, Colors.deepOrange, Colors.lightBlue, Colors.lime,
  ];

  bool showAdvancedOptions = false;
  String? validationError;
  bool hasUserInteracted = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !hasUserInteracted) {
        setState(() {
          hasUserInteracted = true;
        });
      }
    });
    if (widget.baseTextStyle != null) {
      fontSize = widget.baseTextStyle!.fontSize ?? 16.0;
      fontWeight = widget.baseTextStyle!.fontWeight ?? FontWeight.normal;
      textColor = widget.baseTextStyle!.color ?? Colors.black;
      fontFamily = widget.baseTextStyle!.fontFamily ?? 'Roboto';
      fontStyle = widget.baseTextStyle!.fontStyle ?? FontStyle.normal;
      textDecoration = widget.baseTextStyle!.decoration ?? TextDecoration.none;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    if (widget.validator != null && hasUserInteracted) {
      setState(() {
        validationError = widget.validator!(text);
      });
    }
    final formatting = TextFormatting(
      isBold: fontWeight == FontWeight.bold,
      isItalic: fontStyle == FontStyle.italic,
      isUnderline: textDecoration == TextDecoration.underline,
      fontSize: fontSize,
      fontFamily: fontFamily,
      colorValue: textColor.value,
    );

    final content = RichTextContent(
      plainText: text,
      segments: text.isEmpty ? [] : [
        TextSegment(
          text: text,
          start: 0,
          end: text.length,
          formatting: formatting,
        ),
      ],
    );

    widget.onContentChanged(content);
  }

  TextStyle get _currentTextStyle {
    return TextStyle(
      color: textColor,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: textDecoration,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: _currentTextStyle,
          maxLines: widget.maxLines ?? 10,
          minLines: widget.maxLines != null ? 1 : null,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: _currentTextStyle.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
            errorText: validationError,
            errorStyle: const TextStyle(fontSize: 12),
          ),
          validator: widget.validator,
          onTap: () {
            if (!hasUserInteracted) {
              setState(() {
                hasUserInteracted = true;
              });
            }
          },
        ),
        if (widget.showToolbar) ...[
          const SizedBox(height: 8),
          _buildFormattingToolbar(theme),
        ],
      ],
    );
  }

  Widget _buildFormattingToolbar(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FormatButton(
                      icon: Icons.format_bold,
                      label: 'B',
                      isSelected: fontWeight == FontWeight.bold,
                      onPressed: () {
                        setState(() {
                          fontWeight = fontWeight == FontWeight.bold
                              ? FontWeight.normal
                              : FontWeight.bold;
                        });
                        _onTextChanged();
                      },
                      tooltip: 'Bold',
                    ),
                    _FormatButton(
                      icon: Icons.format_italic,
                      label: 'I',
                      isSelected: fontStyle == FontStyle.italic,
                      onPressed: () {
                        setState(() {
                          fontStyle = fontStyle == FontStyle.italic
                              ? FontStyle.normal
                              : FontStyle.italic;
                        });
                        _onTextChanged();
                      },
                      tooltip: 'Italic',
                    ),
                    _FormatButton(
                      icon: Icons.format_underlined,
                      label: 'U',
                      isSelected: textDecoration == TextDecoration.underline,
                      onPressed: () {
                        setState(() {
                          textDecoration = textDecoration == TextDecoration.underline
                              ? TextDecoration.none
                              : TextDecoration.underline;
                        });
                        _onTextChanged();
                      },
                      tooltip: 'Underline',
                    ),

                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(minWidth: 60),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          value: fontSize,
                          isDense: true,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                fontSize = value;
                              });
                              _onTextChanged();
                            }
                          },
                          items: fontSizes.map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(
                              '${size.toInt()}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: showAdvancedOptions
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          showAdvancedOptions ? Icons.expand_less : Icons.expand_more,
                          size: 20,
                          color: showAdvancedOptions
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        onPressed: () {
                          setState(() {
                            showAdvancedOptions = !showAdvancedOptions;
                          });
                        },
                        tooltip: 'More options',
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: showAdvancedOptions ? null : 0,
                child: showAdvancedOptions
                    ? _buildAdvancedOptions(theme, constraints)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdvancedOptions(ThemeData theme, BoxConstraints parentConstraints) {
    return Container(
      width: parentConstraints.maxWidth,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Font Family:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: constraints.maxWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: fontFamily,
                        isExpanded: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              fontFamily = value;
                            });
                            _onTextChanged();
                          }
                        },
                        items: fontFamilies.map((font) => DropdownMenuItem(
                          value: font,
                          child: Text(
                            font,
                            style: TextStyle(fontFamily: font, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Text Color:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80, // Fixed height for color picker
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: colors.map((color) => GestureDetector(
                      onTap: () {
                        setState(() {
                          textColor = color;
                        });
                        _onTextChanged();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: textColor == color
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(alpha: 0.5),
                            width: textColor == color ? 3 : 1,
                          ),
                        ),
                        child: textColor == color
                            ? Icon(
                          Icons.check,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          size: 16,
                        )
                            : null,
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  fontSize = widget.baseTextStyle?.fontSize ?? 16.0;
                  fontWeight = widget.baseTextStyle?.fontWeight ?? FontWeight.normal;
                  textDecoration = widget.baseTextStyle?.decoration ?? TextDecoration.none;
                  fontStyle = widget.baseTextStyle?.fontStyle ?? FontStyle.normal;
                  textColor = widget.baseTextStyle?.color ?? Colors.black;
                  fontFamily = widget.baseTextStyle?.fontFamily ?? 'Roboto';
                });
                _onTextChanged();
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Reset'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final String? tooltip;

  const _FormatButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : null,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ) : null,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontStyle: label == 'I' ? FontStyle.italic : FontStyle.normal,
                decoration: label == 'U' ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}