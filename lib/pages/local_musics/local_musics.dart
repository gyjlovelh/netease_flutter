import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import './scan_local_musics.dart';
import '../../shared/states/global.dart';
import 'dart:io';

class LocalMusics extends StatefulWidget {
  @override
  _LocalMusicsState createState() => _LocalMusicsState();
}

class _LocalMusicsState extends State<LocalMusics>
    with TickerProviderStateMixin {
  //SingleTickerProviderStateMixin

  TabController _tabController;

  List<String> mp3Files = Global.mMp3Files;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
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
              '本地音乐',
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
                      child: Text('扫描本地音乐'),
                      onTap: () {
                        print('开始扫描本地音乐');
                        mp3Files.clear();
                        //todo 扫描本地音乐    /storage/emulated/0
                        var directory = Directory('/storage/emulated/0');
                        List<FileSystemEntity> files = directory.listSync();
                        print('files.length = ' + files.length.toString());
                        for (int i = 0; i < files.length; i++) {
                          // fileName = files[i].path;
                          getAllfilesInDir(files[i]);
                        }
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: Text('选择排序方式'),
                  ),
                  PopupMenuItem(
                    child: Text('获取封面歌词'),
                  ),
                  PopupMenuItem(
                    child: Text('升级音质'),
                  )
                ],
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text(
                    '单曲',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    '歌手',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    '专辑',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    '文件夹',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ScanLocalMusics(),
              ScanLocalMusics(),
              ScanLocalMusics(),
              ScanLocalMusics(),
            ],
          ),
        ),
      ),
    );
  }

  void getAllfilesInDir(FileSystemEntity file) {
    if (FileSystemEntity.isFileSync(file.path)) {//判断是文件还是文件夹
      //判断是否是.mp3文件
      if (file.path.endsWith('.mp3')) {
        setState(() {
          mp3Files.add(file.path);
          print('mp3Files.length = ' + mp3Files.length.toString());
        });
      }
    } else {
      List<FileSystemEntity> files2 = Directory(file.path).listSync();
      if (files2 != null && files2.length != 0) {
        for (int j = 0; j < files2.length; j++) {
          getAllfilesInDir(files2[j]);
        }
      } else {}
    }
  }
}
