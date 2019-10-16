
import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';
@JsonSerializable()
class SongModel {
  String name;
  int id;
  String pic;
  String url;
  List<ArtistModel> ar;
  AlbumModel al;

  SongModel({this.name, this.id, this.url, this.ar, this.al});

  SongModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    url = json['url'];
    if (json['ar'] != null) {
      ar = new List<ArtistModel>();
      json['ar'].forEach((v) {
        ar.add(new ArtistModel.fromJson(v));
      });
    }
    al = json['al'] != null ? new AlbumModel.fromJson(json['al']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['url'] = this.url;
    if (this.ar != null) {
      data['ar'] = this.ar.map((v) => v.toJson()).toList();
    }
    if (this.al != null) {
      data['al'] = this.al.toJson();
    }
    return data;
  }
}
@JsonSerializable()
class ArtistModel {
  int id;
  String name;

  ArtistModel({this.id, this.name});

  ArtistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
@JsonSerializable()
class AlbumModel {
  int id;
  String name;
  String picUrl;

  AlbumModel({this.id, this.name, this.picUrl});

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picUrl = json['picUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picUrl'] = this.picUrl;
    return data;
  }
}