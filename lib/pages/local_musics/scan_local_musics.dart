import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../main.dart';
import 'dart:io';

//本地音乐播放列表
class ScanLocalMusics extends StatefulWidget {
  @override
  _ScanLocalMusicsState createState() => _ScanLocalMusicsState();
}

class _ScanLocalMusicsState extends State<ScanLocalMusics> {
  String fileName = '';
  List<String> mp3Files = List<String>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: noneMusic(),
    );
  }

  void showFileName() {
    print('开始扫描本地音乐');
    mp3Files.clear();
    fileName = '';
    //todo 扫描本地音乐
    var directory = Directory('/storage/emulated/0');
    List<FileSystemEntity> files = directory.listSync();
    for (int i = 0; i < files.length; i++) {
      fileName = files[i].path;
      getAllfilesInDir(files[i]);
    }
  }

  void getAllfilesInDir(FileSystemEntity file) {
    if (FileSystemEntity.isFileSync(file.path)) {//判断是文件还是文件夹
      //判断是否是.mp3文件
      if (file.path.endsWith('.mp3')) {
        mp3Files.add(file.path);
      }
      setState(() {
        fileName = file.path;
        print('---------->>>>>>>>>>>>>>>>filename:' + fileName);
      });
      
    } else {
      List<FileSystemEntity> files2 = Directory(file.path).listSync();
      for (int j = 0; j < files2.length; j++) {
        setState(() {
          fileName = files2[j].path;
          print('---------->>>>>>>>>>>>>>>>filename:' + fileName);
        });
        // getAllfilesInDir(files2[j]);
      }
    }
  }

  Widget noneMusic() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          NeteaseIconData(
            0xe62e,
            color: Colors.grey,
            size: ScreenUtil().setSp(200.0),
          ),
          Text(
            '暂无本地音乐',
            style: TextStyle(
                color: Colors.grey, fontSize: ScreenUtil().setSp(25.0)),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            color: Colors.white,
            child: Text(
              '一键扫描',
              style: TextStyle(fontSize: ScreenUtil().setSp(32.0)),
            ),
            onPressed: () {
              showFileName();
            },
          ),
          Text(
            fileName,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
