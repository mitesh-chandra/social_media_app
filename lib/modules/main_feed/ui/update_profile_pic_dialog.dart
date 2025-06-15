import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';

void showUpdateProfilePicDialog(BuildContext context, String? imagePath) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (context) => _ProfilePictureDialog(initialImagePath: imagePath),
  );
}

class _ProfilePictureDialog extends StatefulWidget {
  final String? initialImagePath;
  const _ProfilePictureDialog({required this.initialImagePath});

  @override
  State<_ProfilePictureDialog> createState() => _ProfilePictureDialogState();
}

class _ProfilePictureDialogState extends State<_ProfilePictureDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? pickedPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    pickedPath = widget.initialImagePath;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      final media = await context.push('${AppRouter.galleryPage}?onlyImage=true&singleSelect=true');
      final path = (media as List<MediaModel>?)?.firstOrNull?.url;

      if (path != null) {
        setState(() => pickedPath = path);
        HapticFeedback.selectionClick();
      }
    } catch (e) {
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _removeImage() {
    setState(() => pickedPath = null);
    HapticFeedback.lightImpact();
  }

  void _updateProfile() {
    context.read<AuthBloc>().updateUserProfileEvent(pickedPath);
    HapticFeedback.mediumImpact();
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isOutlined,
    IconData? icon,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;

    return SizedBox(
      height: 48,
      child: isOutlined
          ? OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: buttonColor),
        label: Text(text, style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500, color: buttonColor)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: buttonColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      )
          : ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? buttonColor : theme.colorScheme.surfaceContainerHighest,
          foregroundColor: onPressed != null ? theme.colorScheme.onPrimary :
          theme.colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18,),
              const SizedBox(width: 8),
            ],
            Text(text, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600,color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = pickedPath != null || widget.initialImagePath != null;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )],
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            backgroundImage: pickedPath != null ? FileImage(File(pickedPath!)) : null,
                            child: pickedPath == null ? (isLoading
                                ? SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                                ))
                                : Icon(Icons.camera_alt_rounded, size: 32,
                                color: theme.colorScheme.onSurfaceVariant)
                            ) : null,
                          ),
                          if (pickedPath != null)
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: theme.colorScheme.surface, width: 3),
                                ),
                                child: Icon(Icons.camera_alt_rounded, size: 18,
                                    color: theme.colorScheme.onPrimary),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Tap to select a new profile picture',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),
                  if (pickedPath != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: _buildButton(
                        text: 'Remove Image',
                        onPressed: _removeImage,
                        isOutlined: true,
                        icon: Icons.delete_outline_rounded,
                        color: theme.colorScheme.error,
                      ),
                    ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildButton(
                        text: 'Cancel',
                        onPressed: () => GoRouter.of(context).pop(),
                        isOutlined: true,
                        icon: Icons.clear,
                        color: Colors.orange,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _buildButton(
                        text: 'Update',
                        onPressed: hasImage ? _updateProfile : null,
                        isOutlined: false,
                        icon: Icons.check_rounded,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}