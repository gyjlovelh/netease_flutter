import 'package:netease_flutter/models/profile.dart';

class CommentModel {
  ProfileModel user;
  List<BeReplied> beReplied;
  int status;
  int commentId;
  String content;
  int time;
  int likedCount;
  int commentLocationType;
  int parentCommentId;
  bool liked;

  CommentModel(
      {this.beReplied,
      this.status,
      this.commentId,
      this.user,
      this.content,
      this.time,
      this.likedCount,
      this.commentLocationType,
      this.parentCommentId,
      this.liked});

  CommentModel.fromJson(Map<String, dynamic> json) {
    if (json['beReplied'] != null) {
      beReplied = new List<BeReplied>();
      json['beReplied'].forEach((v) {
        beReplied.add(new BeReplied.fromJson(v));
      });
    }
    if (json['user'] != null) {
      user = ProfileModel.fromJson(json['user']);
    }
  
    status = json['status'];
    commentId = json['commentId'];
    content = json['content'];
    time = json['time'];
    likedCount = json['likedCount'];
    commentLocationType = json['commentLocationType'];
    parentCommentId = json['parentCommentId'];
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.beReplied != null) {
      data['beReplied'] = this.beReplied.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['commentId'] = this.commentId;
    data['content'] = this.content;
    data['time'] = this.time;
    data['likedCount'] = this.likedCount;
    data['commentLocationType'] = this.commentLocationType;
    data['parentCommentId'] = this.parentCommentId;
    data['liked'] = this.liked;
    return data;
  }
}

class BeReplied {
  int beRepliedCommentId;
  String content;
  int status;

  BeReplied(
      {this.beRepliedCommentId, this.content, this.status});

  BeReplied.fromJson(Map<String, dynamic> json) {
    beRepliedCommentId = json['beRepliedCommentId'];
    content = json['content'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beRepliedCommentId'] = this.beRepliedCommentId;
    data['content'] = this.content;
    data['status'] = this.status;
    return data;
  }
}
