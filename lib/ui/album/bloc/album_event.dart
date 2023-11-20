part of 'album_bloc.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();
}

class LoadDataEvent extends AlbumEvent {
  final bool force;
  LoadDataEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}

class LoadMoreEvent extends AlbumEvent {
  @override
  List<Object?> get props => [];
}

class UpdateFilterEvent extends AlbumEvent {
  final ImageQueryFilter filter;
  UpdateFilterEvent({required this.filter});
  @override
  List<Object?> get props => [filter];
}

class UpdateViewModeEvent extends AlbumEvent {
  final String viewMode;
  UpdateViewModeEvent({required this.viewMode});
  @override
  List<Object?> get props => [viewMode];
}
class OnChangeSelectModeEvent extends AlbumEvent {
  final bool selectMode;
  OnChangeSelectModeEvent({required this.selectMode});
  @override
  List<Object?> get props => [selectMode];
}

class OnUpdateSelectedPhotosEvent extends AlbumEvent {
  final List<int> selectedPhotoIds;
  OnUpdateSelectedPhotosEvent({required this.selectedPhotoIds});
  @override
  List<Object?> get props => [selectedPhotoIds];
}

class OnSelectPhotoEvent extends AlbumEvent {
  final int photoId;
  final bool selected;
  OnSelectPhotoEvent({required this.photoId,required this.selected});
  @override
  List<Object?> get props => [photoId,selected];
}

class DownloadAllAlbumEvent extends AlbumEvent {
  DownloadAllAlbumEvent();
  @override
  List<Object?> get props => [];
}