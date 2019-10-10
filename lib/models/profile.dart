

class ProfileModel {

  final int userId;
  final String nickname;
  final String description;
  final int birthday;
  final int userType;
  final String backgroundUrl;
  final String avatarUrl;
  final int followeds;
  final int follows;
  final int eventCount;
  final int playlistCount;

  ProfileModel({
    this.userId,
    this.nickname,
    this.description,
    this.birthday,
    this.userType,
    this.backgroundUrl,
    this.avatarUrl,
    this.followeds,
    this.follows,
    this.eventCount,
    this.playlistCount
  });

  ProfileModel.fromJson(Map<String, dynamic> json): 
    userId = json['userId'],
    nickname = json['nickname'],
    description = json['description'],
    birthday = json['birthday'],
    userType = json['userType'],
    backgroundUrl = json['backgroundUrl'],
    avatarUrl = json['avatarUrl'],
    followeds = json['followeds'],
    follows = json['follows'],
    eventCount = json['eventCount'],
    playlistCount = json['playlistCount'];

  Map<String, dynamic> toJson() =>
    {
      'userId': userId,
      'nickname': nickname,
      'description': description,
      'birthday': birthday,
      'userType': userType,
      'backgroundUrl': backgroundUrl,
      'avatarUrl': avatarUrl,
      'followeds': followeds,
      'follows': follows,
      'eventCount': eventCount,
      'playlistCount': playlistCount
    };

}
