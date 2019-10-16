// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) {
  return PlaylistModel(
    subscribers: (json['subscribers'] as List)
        ?.map((e) =>
            e == null ? null : ProfileModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    subscribed: json['subscribed'] as bool,
    creator: json['creator'] == null
        ? null
        : ProfileModel.fromJson(json['creator'] as Map<String, dynamic>),
    tracks: (json['tracks'] as List)
        ?.map((e) =>
            e == null ? null : SongModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    updateFrequency: json['updateFrequency'] as String,
    backgroundCoverId: json['backgroundCoverId'] as int,
    backgroundCoverUrl: json['backgroundCoverUrl'] as String,
    titleImage: json['titleImage'] as int,
    titleImageUrl: json['titleImageUrl'] as String,
    englishTitle: json['englishTitle'] as String,
    updateTime: json['updateTime'] as int,
    coverImgId: json['coverImgId'] as int,
    newImported: json['newImported'] as bool,
    specialType: json['specialType'] as int,
    commentThreadId: json['commentThreadId'] as String,
    privacy: json['privacy'] as int,
    trackUpdateTime: json['trackUpdateTime'] as int,
    trackCount: json['trackCount'] as int,
    coverImgUrl: json['coverImgUrl'] as String,
    playCount: json['playCount'] as int,
    trackNumberUpdateTime: json['trackNumberUpdateTime'] as int,
    ordered: json['ordered'] as bool,
    status: json['status'] as int,
    createTime: json['createTime'] as int,
    highQuality: json['highQuality'] as bool,
    adType: json['adType'] as int,
    description: json['description'] as String,
    subscribedCount: json['subscribedCount'] as int,
    cloudTrackCount: json['cloudTrackCount'] as int,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    userId: json['userId'] as int,
    name: json['name'] as String,
    id: json['id'] as int,
    shareCount: json['shareCount'] as int,
    coverImgIdStr: json['coverImgIdStr'] as String,
    commentCount: json['commentCount'] as int,
  );
}

Map<String, dynamic> _$PlaylistModelToJson(PlaylistModel instance) =>
    <String, dynamic>{
      'subscribers': instance.subscribers,
      'subscribed': instance.subscribed,
      'creator': instance.creator,
      'tracks': instance.tracks,
      'updateFrequency': instance.updateFrequency,
      'backgroundCoverId': instance.backgroundCoverId,
      'backgroundCoverUrl': instance.backgroundCoverUrl,
      'titleImage': instance.titleImage,
      'titleImageUrl': instance.titleImageUrl,
      'englishTitle': instance.englishTitle,
      'updateTime': instance.updateTime,
      'coverImgId': instance.coverImgId,
      'newImported': instance.newImported,
      'specialType': instance.specialType,
      'commentThreadId': instance.commentThreadId,
      'privacy': instance.privacy,
      'trackUpdateTime': instance.trackUpdateTime,
      'trackCount': instance.trackCount,
      'coverImgUrl': instance.coverImgUrl,
      'playCount': instance.playCount,
      'trackNumberUpdateTime': instance.trackNumberUpdateTime,
      'ordered': instance.ordered,
      'status': instance.status,
      'createTime': instance.createTime,
      'highQuality': instance.highQuality,
      'adType': instance.adType,
      'description': instance.description,
      'subscribedCount': instance.subscribedCount,
      'cloudTrackCount': instance.cloudTrackCount,
      'tags': instance.tags,
      'userId': instance.userId,
      'name': instance.name,
      'id': instance.id,
      'shareCount': instance.shareCount,
      'coverImgIdStr': instance.coverImgIdStr,
      'commentCount': instance.commentCount,
    };
