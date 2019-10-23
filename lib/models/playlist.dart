
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';

class PlaylistModel {
  List<ProfileModel> subscribers;
  bool subscribed;
  ProfileModel creator;
  List<SongModel> tracks;
  String updateFrequency;
  int backgroundCoverId;
  String backgroundCoverUrl;
  int titleImage;
  String titleImageUrl;
  String englishTitle;
  int updateTime;
  int coverImgId;
  bool newImported;
  int specialType;
  String commentThreadId;
  int privacy;
  int trackUpdateTime;
  int trackCount;
  String coverImgUrl;
  int playCount;
  int trackNumberUpdateTime;
  bool ordered;
  int status;
  int createTime;
  bool highQuality;
  int adType;
  String description;
  int subscribedCount;
  int cloudTrackCount;
  List<String> tags;
  int userId;
  String name;
  int id;
  int shareCount;
  String coverImgIdStr;
  int commentCount;

  PlaylistModel({this.subscribers,
      this.subscribed,
      this.creator,
      this.tracks,
      this.updateFrequency,
      this.backgroundCoverId,
      this.backgroundCoverUrl,
      this.titleImage,
      this.titleImageUrl,
      this.englishTitle,
      this.updateTime,
      this.coverImgId,
      this.newImported,
      this.specialType,
      this.commentThreadId,
      this.privacy,
      this.trackUpdateTime,
      this.trackCount,
      this.coverImgUrl,
      this.playCount,
      this.trackNumberUpdateTime,
      this.ordered,
      this.status,
      this.createTime,
      this.highQuality,
      this.adType,
      this.description,
      this.subscribedCount,
      this.cloudTrackCount,
      this.tags,
      this.userId,
      this.name,
      this.id,
      this.shareCount,
      this.coverImgIdStr,
      this.commentCount});

  PlaylistModel.fromJson(Map<String, dynamic> json) {
    if (json['subscribers'] != null) {
      subscribers = new List<ProfileModel>();
      json['subscribers'].forEach((v) {
        subscribers.add(new ProfileModel.fromJson(v));
      });
    }
    subscribed = json['subscribed'];
    creator =
        json['creator'] != null ? new ProfileModel.fromJson(json['creator']) : null;
    if (json['tracks'] != null) {
      tracks = new List<SongModel>();
      json['tracks'].forEach((v) {
        tracks.add(new SongModel.fromJson(v));
      });
    }
    updateFrequency = json['updateFrequency'];
    backgroundCoverId = json['backgroundCoverId'];
    backgroundCoverUrl = json['backgroundCoverUrl'];
    titleImage = json['titleImage'];
    titleImageUrl = json['titleImageUrl'];
    englishTitle = json['englishTitle'];
    updateTime = json['updateTime'];
    coverImgId = json['coverImgId'];
    newImported = json['newImported'];
    specialType = json['specialType'];
    commentThreadId = json['commentThreadId'];
    privacy = json['privacy'];
    trackUpdateTime = json['trackUpdateTime'];
    trackCount = json['trackCount'];
    coverImgUrl = json['coverImgUrl'];
    playCount = json['playCount'];
    trackNumberUpdateTime = json['trackNumberUpdateTime'];
    ordered = json['ordered'];
    status = json['status'];
    createTime = json['createTime'];
    highQuality = json['highQuality'];
    adType = json['adType'];
    description = json['description'];
    subscribedCount = json['subscribedCount'];
    cloudTrackCount = json['cloudTrackCount'];
    tags = json['tags'] == null?List<String>():json['tags'].cast<String>();
    userId = json['userId'];
    name = json['name'];
    id = json['id'];
    shareCount = json['shareCount'];
    coverImgIdStr = json['coverImgId_str'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscribers != null) {
      data['subscribers'] = this.subscribers.map((v) => v.toJson()).toList();
    }
    data['subscribed'] = this.subscribed;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    if (this.tracks != null) {
      data['tracks'] = this.tracks.map((v) => v.toJson()).toList();
    }
    data['updateFrequency'] = this.updateFrequency;
    data['backgroundCoverId'] = this.backgroundCoverId;
    data['backgroundCoverUrl'] = this.backgroundCoverUrl;
    data['titleImage'] = this.titleImage;
    data['titleImageUrl'] = this.titleImageUrl;
    data['englishTitle'] = this.englishTitle;
    data['updateTime'] = this.updateTime;
    data['coverImgId'] = this.coverImgId;
    data['newImported'] = this.newImported;
    data['specialType'] = this.specialType;
    data['commentThreadId'] = this.commentThreadId;
    data['privacy'] = this.privacy;
    data['trackUpdateTime'] = this.trackUpdateTime;
    data['trackCount'] = this.trackCount;
    data['coverImgUrl'] = this.coverImgUrl;
    data['playCount'] = this.playCount;
    data['trackNumberUpdateTime'] = this.trackNumberUpdateTime;
    data['ordered'] = this.ordered;
    data['status'] = this.status;
    data['createTime'] = this.createTime;
    data['highQuality'] = this.highQuality;
    data['adType'] = this.adType;
    data['description'] = this.description;
    data['subscribedCount'] = this.subscribedCount;
    data['cloudTrackCount'] = this.cloudTrackCount;
    data['tags'] = this.tags;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['id'] = this.id;
    data['shareCount'] = this.shareCount;
    data['coverImgId_str'] = this.coverImgIdStr;
    data['commentCount'] = this.commentCount;
    return data;
  }
}
