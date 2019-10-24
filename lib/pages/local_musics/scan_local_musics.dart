import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import '../../main.dart';

//本地音乐播放列表
class ScanLocalMusics extends StatefulWidget {
  @override
  ScanLocalMusicsState createState() => ScanLocalMusicsState();
}

class ScanLocalMusicsState extends State<ScanLocalMusics>
    with AutomaticKeepAliveClientMixin {
  
  //切换时保持页面状态
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: noneMusic(),
    );
  }

  void showFileName() {
    print('开始扫描本地音乐');
    mp3Files.clear();

    //扫描本地音乐    /storage/emulated/0
    var directory = Directory('/storage/emulated/0');
    List<FileSystemEntity> files = directory.listSync();
    print('files.length = ' + files.length.toString());
    for (int i = 0; i < files.length; i++) {
      getAllfilesInDir(files[i]);
    }
  }

  void getAllfilesInDir(FileSystemEntity file) {
    if (FileSystemEntity.isFileSync(file.path)) {//判断是文件还是文件夹
      //判断是否是.mp3文件
      if (file.path.endsWith('.mp3')) {
        setState(() {
          mp3Files.add(file.path);
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

  Widget noneMusic() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          mp3Files.length == 0
              ? NeteaseIconData(
                  0xe62e,
                  color: Colors.grey,
                  size: ScreenUtil().setSp(200.0),
                )
              : Container(),
          mp3Files.length == 0
              ? Text(
                  '暂无本地音乐',
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(25.0)),
                )
              : Container(),
          mp3Files.length == 0
              ? RaisedButton(
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
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: mp3Files.length,
              itemBuilder: (context, index) {
                String path = mp3Files[index];
                return GestureDetector(
                  onTap: () {
                    //todo 播放音乐
                    Toast.show('播放音乐 : '+path.substring(path.lastIndexOf('/') + 1), context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 4.0),
                    padding: EdgeInsets.only(top: 4.0),
                    width: double.infinity,
                    child: Text(path.substring(path.lastIndexOf('/') + 1)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
