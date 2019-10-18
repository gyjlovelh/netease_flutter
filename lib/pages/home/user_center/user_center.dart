import 'package:flutter/material.dart';
import './icon_buttons/icon_buttons_mine.dart';
import './icon_buttons/icon_buttons_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/icon_data/icon_data.dart';
import './music_list/music_list_vo.dart';
import '../../../models/playlist.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class NeteaseUserCenter extends StatefulWidget {
  @override
  _NeteaseUserCenterState createState() => _NeteaseUserCenterState();
}

class _NeteaseUserCenterState extends State<NeteaseUserCenter> {
  //“创建的歌单” 左侧图标变化   false收起，true展开
  bool _downOrUp = true;
  List<MusicListVO> musicList = List<MusicListVO>();

  //需要显示的歌单List
  void setListData() {
    getPlayList().then((val) {
      musicList.clear();
      var list = val['playlist'] as List;
      List<PlaylistModel> playList =
          list.map((i) => PlaylistModel.fromJson(i)).toList();
      for (int i = 0; i < playList.length; i++) {
        musicList.add(MusicListVO(
            header: playList[i].coverImgUrl,
            title: playList[i].name,
            trackCount: playList[i].trackCount));
      }
      setState(() {});
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

//todo 展开菜单
  Widget showList() {
    // List<MusicListVO> musicList = getMusicList();
    return _downOrUp
        ? (musicList.length == 0
            ? Container()
            : Container(
                child: ListView.builder(
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(musicList[index].header),
                      title:
                          Text(index == 0 ? '我喜欢的音乐' : musicList[index].title),
                      subtitle: Text(musicList[index].trackCount.toString()+'首'),
                      trailing: index == 0 ? null : NeteaseIconData(0xe62b),
                    );
                  },
                ),
              ))
        : Container();
  }

  Widget userActionItem(int pointer, String title, onClick()) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: onClick,
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

  void changeState() {
    print('点击了图标');
    setState(() {
      if(_downOrUp) {
        _downOrUp = false;
      }else {
        _downOrUp = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setListData();

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: iconButtonsMine(getListData()),
          ),
          mDivider(0.5),
          userActionItem(0xe680, '本地音乐', () {
            Navigator.of(context).pushNamed('local_musics');
          }),
          mDivider(0.5),
          userActionItem(0xe625, '最近播放', () {}),
          mDivider(0.5),
          userActionItem(0xe691, '下载管理', () {}),
          mDivider(0.5),
          userActionItem(0xe620, '我的电台', () {}),
          mDivider(0.5),
          userActionItem(0xe621, '我的收藏', () {}),
          mDivider(20.0),
          Row(
            children: <Widget>[
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: _downOrUp ? NeteaseIconData(0xe646) : NeteaseIconData(0xe626),
                  onPressed: changeState,
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
          Expanded(
            child: showList(),
          ),
        ],
      ),
    );
  }
}
