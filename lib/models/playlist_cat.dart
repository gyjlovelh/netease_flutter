class PlaylistCat {
  bool activity;
  bool hot;
  int category;
  int usedCount;
  int createTime;
  int position;
  String name;
  int id;
  int type;

  PlaylistCat(
      {this.activity,
      this.hot,
      this.category,
      this.usedCount,
      this.createTime,
      this.position,
      this.name,
      this.id,
      this.type});

  PlaylistCat.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    hot = json['hot'];
    category = json['category'];
    usedCount = json['usedCount'];
    createTime = json['createTime'];
    position = json['position'];
    name = json['name'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity'] = this.activity;
    data['hot'] = this.hot;
    data['category'] = this.category;
    data['usedCount'] = this.usedCount;
    data['createTime'] = this.createTime;
    data['position'] = this.position;
    data['name'] = this.name;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}
