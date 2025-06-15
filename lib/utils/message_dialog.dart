import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

enum DialogType { error, success, warning, info }

Future<void> showMessageDialog({
  required BuildContext context,
  required String message,
  bool isError = true,
  Duration autoCloseDuration = const Duration(seconds: 3),
  String? title,
  DialogType? type,
  bool barrierDismissible = false,
  bool showAutoCloseIndicator = true,
  VoidCallback? onClose,
}) async {
  final dialogType = type ?? (isError ? DialogType.error : DialogType.success);

  Timer? autoCloseTimer;
  switch (dialogType) {
    case DialogType.error:
      HapticFeedback.heavyImpact();
      break;
    case DialogType.success:
      HapticFeedback.lightImpact();
      break;
    case DialogType.warning:
      HapticFeedback.mediumImpact();
      break;
    case DialogType.info:
      HapticFeedback.selectionClick();
      break;
  }

  autoCloseTimer = Timer(autoCloseDuration, () {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
      onClose?.call();
    }
  });

  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha:0.5),
    builder: (BuildContext dialogContext) {
      return _EnhancedMessageDialog(
        message: message,
        title: title,
        dialogType: dialogType,
        autoCloseDuration: autoCloseDuration,
        showAutoCloseIndicator: showAutoCloseIndicator,
        onClose: () {
          autoCloseTimer?.cancel();
          GoRouter.of(dialogContext).pop();
          onClose?.call();
        },
      );
    },
  );
  autoCloseTimer.cancel();
}

class _EnhancedMessageDialog extends StatefulWidget {
  final String message;
  final String? title;
  final DialogType dialogType;
  final Duration autoCloseDuration;
  final bool showAutoCloseIndicator;
  final VoidCallback onClose;

  const _EnhancedMessageDialog({
    required this.message,
    required this.title,
    required this.dialogType,
    required this.autoCloseDuration,
    required this.showAutoCloseIndicator,
    required this.onClose,
  });

  @override
  State<_EnhancedMessageDialog> createState() => _EnhancedMessageDialogState();
}

class _EnhancedMessageDialogState extends State<_EnhancedMessageDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late AnimationController _progressAnimationController;
  late AnimationController _iconAnimationController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: widget.autoCloseDuration,
      vsync: this,
    );
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.linear,
    ));

    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.elasticOut,
    ));
    _scaleAnimationController.forward();
    _iconAnimationController.forward();

    if (widget.showAutoCloseIndicator) {
      _progressAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _progressAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  DialogConfig _getDialogConfig(ThemeData theme) {
    switch (widget.dialogType) {
      case DialogType.error:
        return DialogConfig(
          icon: Icons.error_outline_rounded,
          title: widget.title ?? 'Error',
          primaryColor: theme.colorScheme.error,
          backgroundColor: theme.colorScheme.errorContainer,
          textColor: theme.colorScheme.onErrorContainer,
        );
      case DialogType.success:
        return DialogConfig(
          icon: Icons.check_circle_outline_rounded,
          title: widget.title ?? 'Success',
          primaryColor: Colors.green,
          backgroundColor: Colors.green.withValues(alpha:0.1),
          textColor: Colors.green.shade700,
        );
      case DialogType.warning:
        return DialogConfig(
          icon: Icons.warning_amber_rounded,
          title: widget.title ?? 'Warning',
          primaryColor: Colors.orange,
          backgroundColor: Colors.orange.withValues(alpha:0.1),
          textColor: Colors.orange.shade700,
        );
      case DialogType.info:
        return DialogConfig(
          icon: Icons.info_outline_rounded,
          title: widget.title ?? 'Information',
          primaryColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getDialogConfig(theme);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha:0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _iconAnimation,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: config.backgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: config.primaryColor.withValues(alpha:0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            config.icon,
                            size: 36,
                            color: config.primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text(
                        config.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha:0.8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),
                if (widget.showAutoCloseIndicator)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Auto-close in',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha:0.6),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                final remaining = (_progressAnimation.value *
                                    widget.autoCloseDuration.inSeconds).ceil();
                                return Text(
                                  '${remaining}s',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: config.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: 1.0 - _progressAnimation.value,
                              backgroundColor: theme.colorScheme.outline.withValues(alpha:0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(config.primaryColor),
                              minHeight: 3,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: widget.onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.close_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Close',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogConfig {
  final IconData icon;
  final String title;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;

  const DialogConfig({
    required this.icon,
    required this.title,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
  });
}
Future<void> showErrorDialog({
  required BuildContext context,
  required String message,
  String? title,
  Duration autoCloseDuration = const Duration(seconds: 3),
  bool barrierDismissible = false,
  VoidCallback? onClose,
}) {
  return showMessageDialog(
    context: context,
    message: message,
    title: title,
    type: DialogType.error,
    autoCloseDuration: autoCloseDuration,
    barrierDismissible: barrierDismissible,
    onClose: onClose,
  );
}

Future<void> showSuccessDialog({
  required BuildContext context,
  required String message,
  String? title,
  Duration autoCloseDuration = const Duration(seconds: 3),
  bool barrierDismissible = false,
  VoidCallback? onClose,
}) {
  return showMessageDialog(
    context: context,
    message: message,
    title: title,
    type: DialogType.success,
    autoCloseDuration: autoCloseDuration,
    barrierDismissible: barrierDismissible,
    onClose: onClose,
  );
}

Future<void> showWarningDialog({
  required BuildContext context,
  required String message,
  String? title,
  Duration autoCloseDuration = const Duration(seconds: 3),
  bool barrierDismissible = false,
  VoidCallback? onClose,
}) {
  return showMessageDialog(
    context: context,
    message: message,
    title: title,
    type: DialogType.warning,
    autoCloseDuration: autoCloseDuration,
    barrierDismissible: barrierDismissible,
    onClose: onClose,
  );
}

Future<void> showInfoDialog({
  required BuildContext context,
  required String message,
  String? title,
  Duration autoCloseDuration = const Duration(seconds: 3),
  bool barrierDismissible = false,
  VoidCallback? onClose,
}) {
  return showMessageDialog(
    context: context,
    message: message,
    title: title,
    type: DialogType.info,
    autoCloseDuration: autoCloseDuration,
    barrierDismissible: barrierDismissible,
    onClose: onClose,
  );
}