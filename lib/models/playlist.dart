

class PlaylistModel {
  int id;
  int type;
  String name; // 歌单名
  String copywriter;
  String picUrl; // 封面图片地址
  int playCount; // 播放量
  int trackCount;

  PlaylistModel.fromJson(Map<String, dynamic> json): 
    id = json['id'],
    type = json['type'],
    name = json['name'],
    copywriter = json['copywriter'],
    picUrl = json['picUrl'],
    playCount = json['playCount'],
    trackCount = json['trackCount'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'copywriter': copywriter,
    'picUrl': picUrl,
    'playCount': playCount,
    'trackCount': trackCount,
  };
}
