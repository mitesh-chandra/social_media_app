import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  static Future<List<MediaModel>> pickMedia(BuildContext context) async {
    final result = await Navigator.push<List<MediaModel>>(
      context,
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
    return result ?? [];
  }

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _mediaAssets = [];
  final List<AssetEntity> _selectedAssets = [];
  bool _loading = true;
  int _currentAlbumIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlbumsAndMedia();
  }

  Future<void> _loadAlbumsAndMedia() async {
    setState(() => _loading = true);
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return;

    final albums = await PhotoManager.getAssetPathList(type: RequestType.common, onlyAll: false);
    _albums = albums;

    await _loadMediaFromAlbum(_albums[_currentAlbumIndex]);
    setState(() => _loading = false);
  }

  Future<void> _loadMediaFromAlbum(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 100);
    setState(() => _mediaAssets = media);
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selectedAssets.contains(asset)) {
        _selectedAssets.remove(asset);
      } else {
        _selectedAssets.add(asset);
      }
    });
  }

  Future<void> _submitSelection() async {
    final List<MediaModel> selected = [];

    for (final asset in _selectedAssets) {
      final file = await asset.file;
      if (file != null) {
        final mediaType = asset.type == AssetType.video ? MediaType.video : MediaType.image;
        selected.add(MediaModel(url: file.path, type: mediaType));
      }
    }

    GoRouter.of(context).pop(selected);
  }

  void _showPreview(AssetEntity asset) async {
    final file = await asset.file;
    if (file == null) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            asset.type == AssetType.video
                ? const Icon(Icons.videocam, size: 100) // Better to use a video player here
                : Image.file(file, fit: BoxFit.contain),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final albumDropdown = DropdownButton<int>(
      value: _currentAlbumIndex,
      items: List.generate(_albums.length, (i) {
        return DropdownMenuItem(
          value: i,
          child: Text(_albums[i].name, overflow: TextOverflow.ellipsis),
        );
      }),
      onChanged: (value) async {
        if (value == null) return;
        setState(() => _currentAlbumIndex = value);
        await _loadMediaFromAlbum(_albums[_currentAlbumIndex]);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Media"),
        actions: [
          if (_selectedAssets.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submitSelection,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.folder),
                const SizedBox(width: 8),
                Expanded(child: albumDropdown),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _mediaAssets.length,
              itemBuilder: (context, index) {
                final asset = _mediaAssets[index];
                final isSelected = _selectedAssets.contains(asset);
                return FutureBuilder<Uint8List?>(
                  future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                  builder: (context, snapshot) {
                    final thumb = snapshot.data;
                    if (thumb == null) {
                      return const Center(child: CircularProgressIndicator(strokeWidth: 1));
                    }
                    return GestureDetector(
                      onTap: () async{
                        final file = await asset.file;
                        final selected = <MediaModel>[];
                        if (file != null) {
                          final mediaType = asset.type == AssetType.video ? MediaType.video : MediaType.image;
                          selected.add(MediaModel(url: file.path, type: mediaType));
                        }
                      context.push(AppRouter.viewMedia,extra: selected);},
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.memory(
                              thumb,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _toggleSelection(asset),
                              child: Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isSelected ? Colors.blue : Colors.white,
                              ),
                            ),
                          ),
                          if (asset.type == AssetType.video)
                            const Positioned(
                              bottom: 4,
                              left: 4,
                              child: Icon(Icons.videocam, color: Colors.white, size: 18),
                            )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
