// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    authStatus: json['authStatus'] as int,
    followed: json['followed'] as bool,
    avatarUrl: json['avatarUrl'] as String,
    accountStatus: json['accountStatus'] as int,
    gender: json['gender'] as int,
    birthday: json['birthday'] as int,
    userId: json['userId'] as int,
    userType: json['userType'] as int,
    nickname: json['nickname'] as String,
    signature: json['signature'] as String,
    description: json['description'] as String,
    detailDescription: json['detailDescription'] as String,
    avatarImgId: json['avatarImgId'] as int,
    backgroundImgId: json['backgroundImgId'] as int,
    backgroundUrl: json['backgroundUrl'] as String,
    authority: json['authority'] as int,
    mutual: json['mutual'] as bool,
    expertTags: json['expertTags'] as String,
    experts: json['experts'] as String,
    djStatus: json['djStatus'] as int,
    vipType: json['vipType'] as int,
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'authStatus': instance.authStatus,
      'followed': instance.followed,
      'avatarUrl': instance.avatarUrl,
      'accountStatus': instance.accountStatus,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'userId': instance.userId,
      'userType': instance.userType,
      'nickname': instance.nickname,
      'signature': instance.signature,
      'description': instance.description,
      'detailDescription': instance.detailDescription,
      'avatarImgId': instance.avatarImgId,
      'backgroundImgId': instance.backgroundImgId,
      'backgroundUrl': instance.backgroundUrl,
      'authority': instance.authority,
      'mutual': instance.mutual,
      'expertTags': instance.expertTags,
      'experts': instance.experts,
      'djStatus': instance.djStatus,
      'vipType': instance.vipType,
    };
