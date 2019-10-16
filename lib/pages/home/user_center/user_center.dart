import 'package:flutter/material.dart';
import 'package:netease_flutter/pages/home/user_center/icon_buttons/icon_buttons_item.dart';
import './icon_buttons/icon_buttons_mine.dart';
import './icon_buttons/icon_buttons_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/pages/icon_data/icon_data.dart';
import './music_list/music_list_vo.dart';
import './music_list/music_list_mine.dart';
import './music_list/music_list_item.dart';
import '../../../models/playlist.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class NeteaseUserCenter extends StatefulWidget {
  @override
  _NeteaseUserCenterState createState() => _NeteaseUserCenterState();
}

class _NeteaseUserCenterState extends State<NeteaseUserCenter> {
  //“创建的歌单” 左侧图标变化   false收起，true展开
  bool _downOrUp = false;

  //需要显示的歌单List
  List<MusicListVO> getMusicList() {
    getPlayList().then((val) {
      PlaylistModel data = PlaylistModel.fromJson(val);
      print('===============>>>>>>>>>>>'+data.name);
    });
  }

  //json获取 歌单List
  Future getPlayList() async {
    Dio dio = Dio();
    Response response =
        await dio.get('http://106.14.154.205:3000/user/playlist?uid=406330413');

    return response.data;
  }

  //ListView Item
  List<IconButtonsVO> getListData() {
    List<IconButtonsVO> list = List<IconButtonsVO>();
    list.add(IconButtonsVO(pointer: 0xe637, label: '云村正能量'));
    list.add(IconButtonsVO(pointer: 0xe610, label: '私人FM'));
    list.add(IconButtonsVO(pointer: 0xeabd, label: '最嗨电音'));
    list.add(IconButtonsVO(pointer: 0xe638, label: 'Sati空间'));
    list.add(IconButtonsVO(pointer: 0xe609, label: '私藏推荐'));
    list.add(IconButtonsVO(pointer: 0xe64a, label: '因乐交友'));
    list.add(IconButtonsVO(pointer: 0xe68c, label: '亲子频道'));
    list.add(IconButtonsVO(pointer: 0xe723, label: '古典专区'));
    list.add(IconButtonsVO(pointer: 0xe611, label: '跑步FM'));
    list.add(IconButtonsVO(pointer: 0xe762, label: '小冰电台'));
    list.add(IconButtonsVO(pointer: 0xe60e, label: '爵士电台'));
    list.add(IconButtonsVO(pointer: 0xe7c8, label: '驾驶模式'));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: iconButtonsMine(getListData()),
          ),
          mDivider(0.5),
          userActionItem(0xe680, '本地音乐'),
          mDivider(0.5),
          userActionItem(0xe625, '最近播放'),
          mDivider(0.5),
          userActionItem(0xe691, '下载管理'),
          mDivider(0.5),
          userActionItem(0xe620, '我的电台'),
          mDivider(0.5),
          userActionItem(0xe621, '我的收藏'),
          mDivider(20.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: _downOrUp
                    ? IconButton(
                        icon: NeteaseIconData(0xe646),
                        onPressed: getMusicList,
                      )
                    : IconButton(
                        icon: NeteaseIconData(0xe626),
                        onPressed: getMusicList,
                      ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '创建的歌单',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30.0),
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: NeteaseIconData(0xe64b),
                  onPressed: () {},
                ),
              ),
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: NeteaseIconData(0xe62b),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          // musicListMine(list),
        ],
      ),
    );
  }
}

//展开菜单

Widget userActionItem(int pointer, String title) {
  return Container(
    width: double.infinity,
    child: GestureDetector(
      onTap: () {},
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: 25.0, right: 25.0, top: 12.0, bottom: 12.0),
            child: NeteaseIconData(
              pointer,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: ScreenUtil().setSp(25.0)),
          ),
        ],
      ),
    ),
  );
}

Widget mDivider(double h) {
  return Divider(
    height: ScreenUtil().setHeight(h),
    color: Colors.grey,
  );
}
