import 'package:youphotomobile/api/base.dart';
import 'package:youphotomobile/api/client.dart';
import 'package:youphotomobile/api/loader.dart';
import 'package:youphotomobile/config.dart';
// {
// "tag": "1girl",
// "source": "auto",
// "rank": 1,
// "imageId": 72
// }
class PhotoTag {
  String? tag;
  String? source;
  double? rank;
  int? imageId;
  PhotoTag.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
  }
}

// {
// "value": "#30261f",
// "imageId": 72,
// "percent": 0.21460176991150443,
// "rank": 0,
// "cnt": 1940
// },
class PhotoColor {
  String? value;
  int? imageId;
  double? percent;
  int? rank;
  int? cnt;
  PhotoColor.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    imageId = json['imageId'];
    percent = double.parse(json['percent'].toString());
    rank = json['rank'];
    cnt = json['cnt'];
  }
}
class Photo {
  int? id;
  String? name;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  String? blurHash;
  List<PhotoTag> tag = [];
  List<PhotoColor> imageColors = [];
  Function(int)? onIndexChange;
  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    blurHash = json['blurHash'];
    if (json['tag'] != null) {
      tag = [];
      json['tag'].forEach((v) {
        tag.add(PhotoTag.fromJson(v));
      });
    }
    if (json['imageColors'] != null) {
      imageColors = [];
      json['imageColors'].forEach((v) {
        imageColors.add(PhotoColor.fromJson(v));
      });
    }
  }

  get thumbnailUrl {
    final token = ApplicationConfig().token;
    return "${ApplicationConfig().serviceUrl}/thumbnail/${this.thumbnail}?a=${ApplicationConfig().token ?? ""}";
  }
  get rawUrl {
    return "${ApplicationConfig().serviceUrl}/image/${id}/raw?a=${ApplicationConfig().token ?? ""}";
  }
}

class PhotoLoader extends ApiDataLoader<Photo> {
  @override
  Future<ListResponseWrap<Photo>> fetchData(Map<String, dynamic> params) {
    return ApiClient().fetchImageList(params);
  }

}

class PhotoTagLoader extends ApiDataLoader<PhotoTag> {
  @override
  Future<ListResponseWrap<PhotoTag>> fetchData(Map<String, dynamic> params) {
    return ApiClient().fetchTagList(params);
  }
}