import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//我喜欢的音乐
class MyLovedMusicsList extends StatefulWidget {
  final String imgUrl; //歌单封面图url
  final String title; //歌单名字
  final int index; //musicList下的歌单索引

  MyLovedMusicsList(
      {Key key,
      @required this.imgUrl,
      @required this.title,
      @required this.index})
      : super(key: key);
  // MyLovedMusicsList(String imgUrl);

  @override
  _MyLovedMusicsListState createState() =>
      _MyLovedMusicsListState(imgUrl, title, index);
}

class _MyLovedMusicsListState extends State<MyLovedMusicsList> {
  String imgUrl;
  String title;
  int index;

  _MyLovedMusicsListState(this.imgUrl, this.title, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: mAppBar(),
        body: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20.0),
                    height: ScreenUtil.instance.setHeight(240.0),
                    width: ScreenUtil.instance.setWidth(240.0),
                    child: Image.network(
                      imgUrl,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: ScreenUtil.instance.setHeight(240.0),
                    width: ScreenUtil.instance.setWidth(240.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      index == 0 ? '我喜欢的音乐' : title,
                      style: TextStyle(decoration: TextDecoration.none,color: Colors.white,fontSize: ScreenUtil.instance.setSp(30.0)),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: mBtnIcon(0xe618, '评论'),
                  ),
                  Expanded(
                    child: mBtnIcon(0xe62f, '分享'),
                  ),
                  Expanded(
                    child: mBtnIcon(0xe63b, '下载'),
                  ),
                  Expanded(
                    child: mBtnIcon(0xe633, '多选'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mBtnIcon(int pointer, String btnTitle) {
    return Container(
      child: Column(
        children: <Widget>[
          NeteaseIconData(pointer,color: Colors.white,),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
            btnTitle,

            style: TextStyle(decoration: TextDecoration.none,fontSize: ScreenUtil.instance.setSp(20.0),color: Colors.white),
          ),
          ),
          
        ],
      ),
    );
  }

  AppBar mAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: NeteaseIconData(
          0xe62d,
          color: Colors.white,
        ),
      ),
      title: Text(
        '歌单',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: NeteaseIconData(
            0xe60c,
            color: Colors.white,
          ),
          onPressed: () {
            //todo 跳转到搜索界面
            Navigator.of(context).pushNamed('search');
          },
        ),
        PopupMenuButton(
          child: Container(
            margin: EdgeInsets.only(right: 4.0),
            child: NeteaseIconData(
              0xe8f5,
              color: Colors.white,
            ),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            PopupMenuItem(
              child: GestureDetector(
                child: Text('WiFi下自动下载新增歌曲'),
                onTap: () {},
              ),
            ),
            PopupMenuItem(
              child: Text('添加歌曲'),
            ),
            PopupMenuItem(
              child: Text('更改歌曲排序'),
            ),
            PopupMenuItem(
              child: Text('清空下载文件'),
            )
          ],
        )
      ],
    );
  }
}
