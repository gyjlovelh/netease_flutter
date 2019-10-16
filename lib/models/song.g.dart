// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) {
  return SongModel(
    name: json['name'] as String,
    id: json['id'] as int,
    url: json['url'] as String,
    ar: (json['ar'] as List)
        ?.map((e) =>
            e == null ? null : ArtistModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    al: json['al'] == null
        ? null
        : AlbumModel.fromJson(json['al'] as Map<String, dynamic>),
  )..pic = json['pic'] as String;
}

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'pic': instance.pic,
      'url': instance.url,
      'ar': instance.ar,
      'al': instance.al,
    };

ArtistModel _$ArtistModelFromJson(Map<String, dynamic> json) {
  return ArtistModel(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ArtistModelToJson(ArtistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) {
  return AlbumModel(
    id: json['id'] as int,
    name: json['name'] as String,
    picUrl: json['picUrl'] as String,
  );
}

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picUrl': instance.picUrl,
    };
