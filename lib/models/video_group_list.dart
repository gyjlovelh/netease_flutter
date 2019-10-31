class VideoGroupListModel {
  int id;
  String name;
  String url;
  String relatedVideoType;
  bool selectTab;
  String abExtInfo;

  VideoGroupListModel(
      {this.id,
      this.name,
      this.url,
      this.relatedVideoType,
      this.selectTab,
      this.abExtInfo});

  VideoGroupListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    relatedVideoType = json['relatedVideoType'];
    selectTab = json['selectTab'];
    abExtInfo = json['abExtInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['relatedVideoType'] = this.relatedVideoType;
    data['selectTab'] = this.selectTab;
    data['abExtInfo'] = this.abExtInfo;
    return data;
  }
}