import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youphotomobile/api/client.dart';

import '../../../api/image.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  PhotoLoader loader = PhotoLoader();
  final albumId;
  AlbumBloc({
    required this.albumId,
}) : super(AlbumInitial()) {
    on<LoadDataEvent>((event, emit) async {
      if (await loader.loadData(force: event.force,extraFilter: _getExtraParams(state.filter))){
        emit(state.copyWith(photos: [...loader.list]));
      }
    });
    on<LoadMoreEvent>((event, emit) async {
      if (await loader.loadMore(extraFilter: _getExtraParams(state.filter))){
        emit(state.copyWith(photos: [...loader.list]));
      }
    });
    on<UpdateFilterEvent>((event, emit) async {
      print(event.filter);
      await loader.loadData(extraFilter: _getExtraParams(event.filter),force: true);
      emit(state.copyWith(photos: [...loader.list],filter: event.filter));
    });
    on<UpdateViewModeEvent>((event, emit) async {
      emit(state.copyWith(viewMode: event.viewMode));
    });
    on<OnChangeSelectModeEvent>((event, emit) async {
      emit(state.copyWith(selectMode: event.selectMode));
    });
    on<OnUpdateSelectedPhotosEvent>((event, emit) async {
      emit(state.copyWith(selectedPhotoIds: event.selectedPhotoIds));
    });
    on<OnSelectPhotoEvent>((event, emit) async {
      List<int> selectedPhotoIds = [...state.selectedPhotoIds];
      if (event.selected) {
        selectedPhotoIds.add(event.photoId);
      } else {
        selectedPhotoIds.remove(event.photoId);
      }
      emit(state.copyWith(selectedPhotoIds: selectedPhotoIds));
    });
    on<DownloadAllAlbumEvent>((event, emit) async {
      emit(state.copyWith(isDownloadingAll: true));
      var resp = await ApiClient().fetchImageList({
        "albumId":albumId,
        "pageSize":100000,
        "page":1
      });
      if (resp.result.isEmpty) {
        return;
      }
      for (var photo in resp.result) {
        print("download image from :" + photo.rawUrl);
        emit(state.copyWith(downloadProgress: DownloadAllImageProgress(total: resp.result.length,current: resp.result.indexOf(photo),name: photo.name)));
        var response = await Dio().get(
            photo.rawUrl,
            options: Options(
                responseType: ResponseType.bytes));
        try {
          await ImageGallerySaver.saveImage(
              Uint8List.fromList(response.data),
              quality: 100,
              name: photo.name);
        } catch (e) {
          print(e);
          continue;
        }
      }
      emit(state.copyWith(isDownloadingAll: false));
    });
  }
  Map<String,dynamic> _getExtraParams(ImageQueryFilter filter) {
    Map<String,dynamic> result = {
      "order":filter.order,
      "pageSize":"200",
      "random":filter.random ? "1" : "",
      "tag":filter.tag,
      "albumId":albumId,
    };
    if (filter.libraryIds.isNotEmpty) {
      for (var id in filter.libraryIds) {
        result["libraryId"] = id.toString();
      }
    }
    return result;
  }
}
