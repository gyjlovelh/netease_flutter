
class PlaylistArguments {
  int id;
  String name;
  String coverImgUrl;
  String copywriter;

  PlaylistArguments({this.id, this.name, this.coverImgUrl, this.copywriter});

  PlaylistArguments.fromJson(json) {
    id = json['id'];
    name = json['name'];
    coverImgUrl = json['coverImgUrl'];
    copywriter = json['copywriter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['coverImgUrl'] = this.coverImgUrl;
    data['copywriter'] = this.copywriter;
    return data;
  }
}
