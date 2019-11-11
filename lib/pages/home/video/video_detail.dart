import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../../models/video_group.dart';
import '../../../shared/service/request_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/loading/loading.dart';
import '../../../shared/widgets/icon_data/icon_data.dart';
import '../../../shared/utils/common_utils.dart';
import 'package:video_player/video_player.dart';

//视频详情页
class VideoDetail extends StatefulWidget {
  final int id;

  VideoDetail({Key key, @required this.id}) : super(key: key);

  @override
  _VideoDetailState createState() => _VideoDetailState(id: id);
}

class _VideoDetailState extends State<VideoDetail> {
  int id; //videoGroup的id
  List<VideoData> videoGroups = List<VideoData>();
  VideoPlayerController _controller;

  _VideoDetailState({@required this.id});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RequestService.getInstance(context: context).getVideoGroup(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          videoGroups.clear();
          List list = snapshot.data['datas'] as List;
          for (int i = 0; i < list.length; i++) {
            VideoGroupModel v = VideoGroupModel.fromJson(list[i]);
            if (v.type == 1) {
              videoGroups.add(v.data);
            }
          }
          // videoGroups = list.map((i) {
          //   // print('视频 iii[data] = ' + VideoData.fromJson(i['data']).coverUrl);
          //   if (i['type'] == 1) {
          //     return VideoData.fromJson(i['data']);
          //   }
          //   return null;
          // }).toList();
          // print('视频 videoGroups.length = '+videoGroups.length.toString());
          return Container(
            child: videoGroups.length == 0 ? Container() : videoDetail(),
          );
        } else {
          return Center(
            child: NeteaseLoading(),
          );
        }
      },
    );
  }

  Widget videoDetailItem(int index) {
    var container = Container(
      alignment: Alignment.topRight,
      // decoration: BoxDecoration(
      // border: Border.all(color: Colors.white, width: 0.5),//边框
      // borderRadius: BorderRadius.circular(ScreenUtil.instance.setWidth(20.0)),
      // ),
      child: Text(
        videoGroups[index].title,
        style: TextStyle(
            fontSize: ScreenUtil.instance.setSp(18.0), color: Colors.white),
      ),
    );
    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil.getInstance().setHeight(300.0),
          margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10.0,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(videoGroups[index].coverUrl),
                fit: BoxFit.cover),
            borderRadius:
                BorderRadius.circular(ScreenUtil.instance.setWidth(20.0)),
          ),
          child: index == 0 //播放视频
              ? _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container()
              : Stack(
                  children: <Widget>[
                    container,
                    Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                        ),
                        color: Colors.white,
                        iconSize: 40.0,
                        onPressed: () {
                          print('视频播放地址：' + videoGroups[index].urlInfo.url);
                          // Toast.show('播放视频: ' + videoGroups[index].title,context);
                          videoGroups[index].subscribed = true;
                          _controller = VideoPlayerController.network(
                              videoGroups[index].urlInfo.url)
                            ..initialize().then((_) {
                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                              setState(() {});
                            });
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            videoGroups[index].playTime.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          NeteaseIconData(
                            0xe634,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          Text(
                            formatMath((videoGroups[index].durationms)),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
          child: Text(
            videoGroups[index].description ??= '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            maxLines: 2,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  videoGroups[index].creator.avatarUrl,
                  width: ScreenUtil.instance.setWidth(50.0),
                  height: ScreenUtil.instance.setHeight(50.0),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(
                  videoGroups[index].creator.nickname,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget videoDetail() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoGroups.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: videoDetailItem(index),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
}
