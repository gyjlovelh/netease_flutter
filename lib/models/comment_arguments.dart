class CommentArguments {
  int id;
  String type;
  int commentCount;

  CommentArguments({this.id, this.type, this.commentCount});

  CommentArguments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    commentCount = json['commentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['commentCount'] = this.commentCount;
    return data;
  }
}
