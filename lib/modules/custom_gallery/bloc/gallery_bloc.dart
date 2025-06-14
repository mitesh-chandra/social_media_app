// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:social_media_app/modules/post/model/post_model.dart';
//
// part 'gallery_event.dart';
// part 'gallery_state.dart';
// part 'gallery_store.dart';
//
// class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
//   GalleryBloc() : super(const GalleryState()) {
//     on<LoadAssets>(_onLoadAssets);
//     on<ToggleSelection>(_onToggleSelection);
//     on<ClearSelection>(_onClearSelection);
//   }
//
//   Future<void> _onLoadAssets(LoadAssets event, Emitter<GalleryState> emit) async {
//     emit(state.copyWith(isLoading: true));
//
//     final permission = await PhotoManager.requestPermissionExtend();
//     if (!permission.isAuth) {
//       emit(state.copyWith(isLoading: false, error: 'Permission denied'));
//       return;
//     }
//
//     final albums = await PhotoManager.getAssetPathList(type: RequestType.all);
//     final recent = albums.first;
//     final media = await recent.getAssetListPaged(page: 0, size: 100);
//
//     final assets = media.map((asset) async {
//       final file = await asset.file;
//       if (file == null) return null;
//       return MediaModel(
//         id: asset.id,
//         url: file.path,
//         type: asset.type == AssetType.image ? MediaType.image : MediaType.video,
//       );
//     });
//
//     final resolvedAssets = await Future.wait(assets);
//     final filtered = resolvedAssets.whereType<MediaAsset>().toList();
//
//     emit(state.copyWith(assets: filtered, isLoading: false));
//   }
//
//   void _onToggleSelection(ToggleSelection event, Emitter<GalleryState> emit) {
//     final current = [...state.selectedAssets];
//     if (current.any((a) => a.id == event.asset.id)) {
//       current.removeWhere((a) => a.id == event.asset.id);
//     } else {
//       current.add(event.asset);
//     }
//     emit(state.copyWith(selectedAssets: current));
//   }
//
//   void _onClearSelection(ClearSelection event, Emitter<GalleryState> emit) {
//     emit(state.copyWith(selectedAssets: []));
//   }
// }
