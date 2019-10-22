

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
}
