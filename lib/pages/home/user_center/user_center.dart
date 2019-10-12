import 'package:flutter/material.dart';
import 'package:netease_flutter/pages/home/user_center/icon_buttons_item.dart';
import './icon_buttons_mine.dart';
import './icon_buttons_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeteaseUserCenter extends StatefulWidget {
  @override
  _NeteaseUserCenterState createState() => _NeteaseUserCenterState();
}

class _NeteaseUserCenterState extends State<NeteaseUserCenter> {

  //ListView Item
  List<IconButtonsVO> getListData() {
    List<IconButtonsVO> list = List<IconButtonsVO>();
    list.add(IconButtonsVO(pointer:0xe637,label:'云村正能量'));
    list.add(IconButtonsVO(pointer:0xe610,label:'私人FM'));
    list.add(IconButtonsVO(pointer:0xeabd,label:'最嗨电音'));
    list.add(IconButtonsVO(pointer:0xe638,label:'Sati空间'));
    list.add(IconButtonsVO(pointer:0xe609,label:'私藏推荐'));
    list.add(IconButtonsVO(pointer:0xe64a,label:'因乐交友'));
    list.add(IconButtonsVO(pointer:0xe68c,label:'亲子频道'));
    list.add(IconButtonsVO(pointer:0xe723,label:'古典专区'));
    list.add(IconButtonsVO(pointer:0xe611,label:'跑步FM'));
    list.add(IconButtonsVO(pointer:0xe762,label:'小冰电台'));
    list.add(IconButtonsVO(pointer:0xe60e,label:'爵士电台'));
    list.add(IconButtonsVO(pointer:0xe7c8,label:'驾驶模式'));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: iconButtonsMine(getListData()),
      /*Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          
        ],
      ),*/
    );
  }
}

