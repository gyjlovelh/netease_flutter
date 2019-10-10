

import 'song.dart';

class BannerModel extends Object {

  final String bannerId;
  final String typeTitle;
  final String pic;
  final String titleColor;
  // final Song song;

  BannerModel(
    this.bannerId,
    this.pic,
    this.typeTitle,
    // this.song,
    this.titleColor
  );

  BannerModel.fromJson(Map<String, dynamic> json): 
    bannerId = json['bannerId'],
    pic = json['pic'],
    typeTitle = json['typeTitle'],
    // song = json['song'],
    titleColor = json['titleColor'];

  Map<String, dynamic> toJson() => {
    'bannerId': bannerId,
    'pic': pic,
    'typeTitle': typeTitle,
    // 'song': song,
    'titleColor': titleColor
  };
}
