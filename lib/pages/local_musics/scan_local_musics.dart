import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import '../../shared/states/global.dart';
import 'package:provider/provider.dart';
import 'package:netease_flutter/shared/player/music_player_status.dart';
import 'package:audioplayer/audioplayer.dart';

//本地音乐播放列表
class ScanLocalMusics extends StatefulWidget {
  @override
  ScanLocalMusicsState createState() => ScanLocalMusicsState();
}

class ScanLocalMusicsState extends State<ScanLocalMusics>
    with AutomaticKeepAliveClientMixin {
  List<String> mp3Files = Global.mMp3Files;

  //切换时保持页面状态
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: musicContent(context),
    );
  }

  void showFileName() {
    print('开始扫描本地音乐');
    mp3Files.clear();

    // Navigator.of(context).pushNamed('loading');
    // Navigator.of(context).push(MaterialPageRoute(builder:(context){return LoadingDialog();},));
    // Navigator.push(context, DialogRouter(LoadingDialog()));

    //扫描本地音乐    /storage/emulated/0
    var directory = Directory('/storage/emulated/0');
    List<FileSystemEntity> files = directory.listSync();
    print('files.length = ' + files.length.toString());
    for (int i = 0; i < files.length; i++) {
      getAllfilesInDir(files[i]);
    }
  }

  void getAllfilesInDir(FileSystemEntity file) {
    //判断是文件还是文件夹
    if (FileSystemEntity.isFileSync(file.path)) {
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

  Widget musicContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          mp3Files.length == 0
              ? NeteaseIconData(
                  0xe62e,
                  color: Colors.grey,
                  size: ScreenUtil.instance.setSp(200.0),
                )
              : Container(),
          mp3Files.length == 0
              ? Text(
                  '暂无本地音乐',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil.instance.setSp(25.0)),
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
                    style: TextStyle(fontSize: ScreenUtil.instance.setSp(32.0)),
                  ),
                  onPressed: () {
                    //todo 弹框未生效
                    // Navigator.push(context, DialogRouter(LoadingDialog()));
                    // Navigator.of(context).pushNamed('playlist_square');
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('扫描中...'),
                          );
                        },
                        barrierDismissible: false);
                    Toast.show('正在扫描...', context);

                    showFileName();

                    Toast.show('扫描完成', context);
                    Navigator.pop(context);

                    if (mp3Files.length == 0) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('未扫描到音乐文件!'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('确定'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                )
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: mp3Files.length,
              itemBuilder: (context, index) {
                String path = mp3Files[index];
                return Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //todo 播放音乐
                        File file = File(mp3Files[index]);
                        file.exists().then((isExists) {
                          if (isExists) {
                            playMusic(index);
                          } else {
                            setState(() {
                              Toast.show('该歌曲不存在', context);
                              Global.mMp3Files.remove(index);
                            });
                          }
                        });
                        playMusic(index);
                        Toast.show(
                            '播放音乐 : ' +
                                path.substring(path.lastIndexOf('/') + 1),
                            context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 4.0),
                        padding: EdgeInsets.only(top: 4.0),
                        width: double.infinity,
                        child: Text(
                          path.substring(path.lastIndexOf('/') + 1),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: ScreenUtil.instance.setHeight(0.5),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void playMusic(int index) async {
    // final provider = Provider.of<MusicChangeNotifier>(context);
    final stateProvider = Provider.of<PlayerStatusNotifier>(context);

    if (stateProvider.playerState == AudioPlayerState.PLAYING) {
      await stateProvider.stop();
    }
    // stateProvider.choosePlayList(detail.tracks);
    // provider.loadMusic(song);
    stateProvider.playLocal(mp3Files[index]);
  }
}
