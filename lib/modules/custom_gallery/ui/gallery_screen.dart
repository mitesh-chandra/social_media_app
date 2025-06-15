import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:video_player/video_player.dart';

class GalleryScreen extends StatefulWidget {
  final bool onlyImage;
  final bool singleSelect;

  const GalleryScreen({
    super.key,
    this.onlyImage = false,
    this.singleSelect = false,
  });

  static Future<List<MediaModel>> pickMedia(
      BuildContext context, {
        bool onlyImage = false,
        bool singleSelect = false,
      }) async {
    final result = await Navigator.push<List<MediaModel>>(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryScreen(
          onlyImage: onlyImage,
          singleSelect: singleSelect,
        ),
      ),
    );
    return result ?? [];
  }

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _mediaAssets = [];
  final ValueNotifier<Set<String>> _selectedAssets = ValueNotifier<Set<String>>({});
  bool _loading = true;
  bool _hasPermission = false;
  int _currentAlbumIndex = 0;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadAlbumsAndMedia();
  }

  @override
  void dispose() {
    _selectedAssets.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadAlbumsAndMedia() async {
    setState(() => _loading = true);

    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      setState(() {
        _loading = false;
        _hasPermission = false;
      });
      return;
    }

    _hasPermission = true;
    final albums = await PhotoManager.getAssetPathList(
      type: widget.onlyImage ? RequestType.image : RequestType.common,
      onlyAll: false,
    );

    if (albums.isNotEmpty) {
      _albums = albums;
      await _loadMediaFromAlbum(_albums[_currentAlbumIndex]);
    }

    setState(() => _loading = false);
    _fadeAnimationController.forward();
  }

  Future<void> _loadMediaFromAlbum(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 100);
    setState(() => _mediaAssets = media);
  }

  void _toggleSelection(AssetEntity asset) {
    final currentSelection = Set<String>.from(_selectedAssets.value);

    if (widget.singleSelect) {
      currentSelection.clear();
      currentSelection.add(asset.id);
    } else {
      if (currentSelection.contains(asset.id)) {
        currentSelection.remove(asset.id);
      } else {
        currentSelection.add(asset.id);
      }
    }

    _selectedAssets.value = currentSelection;
  }

  Future<void> _submitSelection() async {
    final selectedIds = _selectedAssets.value;
    final List<MediaModel> selected = [];

    for (final asset in _mediaAssets) {
      if (selectedIds.contains(asset.id)) {
        final file = await asset.file;
        if (file != null) {
          final mediaType = asset.type == AssetType.video ? MediaType.video : MediaType.image;
          selected.add(MediaModel(url: file.path, type: mediaType));
        }
      }
    }

    GoRouter.of(context).pop(selected);
  }

  Future<void> _viewMedia(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) return;

    final selected = <MediaModel>[];
    final mediaType = asset.type == AssetType.video ? MediaType.video : MediaType.image;
    selected.add(MediaModel(url: file.path, type: mediaType));
    final controller = VideoPlayerController.file(file);
    controller.initialize();
    context.push(AppRouter.viewMedia, extra: (selected,[controller])).then((_){
      controller.dispose();
    });
  }

  Widget _buildPermissionDenied(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 40,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Permission Required',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We need access to your photos and videos to let you select media for your posts.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await PhotoManager.openSetting();
                _loadAlbumsAndMedia();
              },
              icon: const Icon(Icons.settings_rounded),
              label: const Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.photo_outlined,
                size: 40,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Media Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No ${widget.onlyImage ? 'images' : 'media files'} found in this album.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumSelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _currentAlbumIndex,
          isExpanded: true,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          items: List.generate(_albums.length, (i) {
            return DropdownMenuItem(
              value: i,
              child: Row(
                children: [
                  Icon(
                    Icons.folder_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),

                  const SizedBox(width: 12),
                  Text(
                    _albums[i].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }),
          onChanged: (value) async {
            if (value == null) return;
            _currentAlbumIndex = value;
            await _loadMediaFromAlbum(_albums[_currentAlbumIndex]);
          },
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.onlyImage ? Icons.image_rounded : Icons.perm_media_rounded,
                color: theme.colorScheme.onPrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select ${widget.onlyImage ? 'Images' : 'Media'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: _selectedAssets,
                  builder: (context, selectedAssets, child) {
                    if (selectedAssets.isEmpty) return const SizedBox();
                    return Text(
                      '${selectedAssets.length} ${widget.singleSelect ? 'item' : 'items'} selected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: _selectedAssets,
            builder: (context, selectedAssets, child) {
              if (selectedAssets.isEmpty) return const SizedBox();

              return Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary,
                      theme.colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _submitSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.onSecondary,
                  ),
                  label: Text(
                    'Done',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading ${widget.onlyImage ? 'images' : 'media'}...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      )
          : !_hasPermission
          ? _buildPermissionDenied(theme)
          : _albums.isEmpty
          ? _buildEmptyState(theme)
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildAlbumSelector(theme),
            Expanded(
              child: _mediaAssets.isEmpty
                  ? _buildEmptyState(theme)
                  : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _mediaAssets.length,
                itemBuilder: (context, index) {
                  final asset = _mediaAssets[index];
                  return MediaGridItem(
                    key: ValueKey(asset.id),
                    asset: asset,
                    selectedAssets: _selectedAssets,
                    singleSelect: widget.singleSelect,
                    onToggleSelection: () => _toggleSelection(asset),
                    onViewMedia: () => _viewMedia(asset),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaGridItem extends StatefulWidget {
  final AssetEntity asset;
  final ValueNotifier<Set<String>> selectedAssets;
  final bool singleSelect;
  final VoidCallback onToggleSelection;
  final VoidCallback onViewMedia;

  const MediaGridItem({
    required super.key,
    required this.asset,
    required this.selectedAssets,
    required this.singleSelect,
    required this.onToggleSelection,
    required this.onViewMedia,
  });

  @override
  State<MediaGridItem> createState() => _MediaGridItemState();
}

class _MediaGridItemState extends State<MediaGridItem> with SingleTickerProviderStateMixin {
  Uint8List? _thumbnail;
  bool _loading = true;
  late AnimationController _selectionAnimationController;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _selectionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _selectionAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadThumbnail();
  }

  @override
  void dispose() {
    _selectionAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadThumbnail() async {
    try {
      final thumb = await widget.asset.thumbnailDataWithSize(
        const ThumbnailSize(300, 300),
      );
      if (mounted) {
        setState(() {
          _thumbnail = thumb;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onTap() {
    widget.onToggleSelection();
    _selectionAnimationController.forward().then((_) {
      _selectionAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: widget.selectedAssets,
      builder: (context, selectedAssets, child) {
        final isSelected = selectedAssets.contains(widget.asset.id);

        return AnimatedBuilder(
          animation: _selectionAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _selectionAnimation.value : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  )
                      : null,
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onViewMedia,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _loading
                                ? Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                                : _thumbnail != null
                                ? Image.memory(
                              _thumbnail!,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _onTap,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Icon(
                                  Icons.check_rounded,
                                  color: theme.colorScheme.onPrimary,
                                  size: 14,
                                )
                                    : null,
                              ),
                            ),
                          ),
                          if (widget.asset.type == AssetType.video)
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.videocam_rounded,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      _formatDuration(widget.asset.duration),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


}