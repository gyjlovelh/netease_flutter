class RecommentPlaylistModel {
  int id;
  int type;
  String name;
  String copywriter;
  String picUrl;
  bool canDislike;
  int playCount;
  int trackCount;
  bool highQuality;
  String alg;

  RecommentPlaylistModel(
      {this.id,
      this.type,
      this.name,
      this.copywriter,
      this.picUrl,
      this.canDislike,
      this.playCount,
      this.trackCount,
      this.highQuality,
      this.alg});

  RecommentPlaylistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    copywriter = json['copywriter'];
    picUrl = json['picUrl'];
    canDislike = json['canDislike'];
    playCount = json['playCount'];
    trackCount = json['trackCount'];
    highQuality = json['highQuality'];
    alg = json['alg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['copywriter'] = this.copywriter;
    data['picUrl'] = this.picUrl;
    data['canDislike'] = this.canDislike;
    data['playCount'] = this.playCount;
    data['trackCount'] = this.trackCount;
    data['highQuality'] = this.highQuality;
    data['alg'] = this.alg;
    return data;
  }
}
