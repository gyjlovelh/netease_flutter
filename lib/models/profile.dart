
class ProfileModel {
  int authStatus;
  bool followed;
  String avatarUrl;
  int accountStatus;
  int gender;
  int birthday;
  int userId;
  int userType;
  String nickname;
  String signature;
  String description;
  String detailDescription;
  int avatarImgId;
  int backgroundImgId;
  String backgroundUrl;
  int authority;
  bool mutual;
  int djStatus;
  int vipType;
  int follows;
  int followeds;
  int allSubscribedCount; // 订阅数
  int playlistBeSubscribedCount; // 歌单被收藏数量

  ProfileModel(
      {this.authStatus,
      this.followed,
      this.avatarUrl,
      this.accountStatus,
      this.gender,
      this.birthday,
      this.userId,
      this.userType,
      this.nickname,
      this.signature,
      this.description,
      this.detailDescription,
      this.avatarImgId,
      this.backgroundImgId,
      this.backgroundUrl,
      this.authority,
      this.mutual,
      this.djStatus,
      this.vipType,
      this.followeds,
      this.follows,
      this.allSubscribedCount,
      this.playlistBeSubscribedCount
    });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    authStatus = json['authStatus'];
    followed = json['followed'];
    avatarUrl = json['avatarUrl'];
    accountStatus = json['accountStatus'];
    gender = json['gender'];
    birthday = json['birthday'];
    userId = json['userId'];
    userType = json['userType'];
    nickname = json['nickname'];
    signature = json['signature'];
    description = json['description'];
    detailDescription = json['detailDescription'];
    avatarImgId = json['avatarImgId'];
    backgroundImgId = json['backgroundImgId'];
    backgroundUrl = json['backgroundUrl'];
    authority = json['authority'];
    mutual = json['mutual'];
    djStatus = json['djStatus'];
    follows = json['follows'];
    followeds = json['followeds'];
    vipType = json['vipType'];
    allSubscribedCount = json['allSubscribedCount'];
    playlistBeSubscribedCount = json['playlistBeSubscribedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authStatus'] = this.authStatus;
    data['followed'] = this.followed;
    data['avatarUrl'] = this.avatarUrl;
    data['accountStatus'] = this.accountStatus;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['userId'] = this.userId;
    data['userType'] = this.userType;
    data['nickname'] = this.nickname;
    data['signature'] = this.signature;
    data['description'] = this.description;
    data['detailDescription'] = this.detailDescription;
    data['avatarImgId'] = this.avatarImgId;
    data['backgroundImgId'] = this.backgroundImgId;
    data['backgroundUrl'] = this.backgroundUrl;
    data['authority'] = this.authority;
    data['mutual'] = this.mutual;
    data['djStatus'] = this.djStatus;
    data['vipType'] = this.vipType;
    data['followeds'] = this.followeds;
    data['follows'] = this.follows;
    data['allSubscribedCount'] = this.allSubscribedCount;
    data['playlistBeSubscribedCount'] = this.playlistBeSubscribedCount;
    return data;
  }
}
