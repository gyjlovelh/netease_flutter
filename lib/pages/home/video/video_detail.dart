import 'package:flutter/material.dart';
import '../../../models/video_group.dart';
import '../../../shared/service/request_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//视频详情页
class VideoDetail extends StatefulWidget {
  int id;

  VideoDetail({Key key, @required this.id}) : super(key: key);

  @override
  _VideoDetailState createState() => _VideoDetailState(id: id);
}

class _VideoDetailState extends State<VideoDetail> {
  int id; //videoGroup的id
  List<VideoData> videoGroups = List<VideoData>();

  _VideoDetailState({@required this.id});

  void setVideoGroupsData(BuildContext context) {
    RequestService.getInstance(context: context).getVideoGroup(id).then((val) {
      videoGroups.clear();
      var list = val['datas'] as List;
      print('视频 list.length = ' + list.length.toString());

      for (int i = 0; i < list.length; i++) {
        try {
          videoGroups.add(VideoData.fromJson(list[i]['data']));
        } catch (e) {
          print(e);
        }
      }

      // try {
      //   videoGroups = list.map((i) {
      //     print('视频 iii[data] = ' + i['data'].toString());
      //     return VideoData.fromJson(i['data']);
      //   }).toList();
      // } catch (e) {
      //   print(e);
      // }

      setState(() {
        print('视频 videoGroups.length = ' + videoGroups.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setVideoGroupsData(context);

    return Container(
      child: videoGroups.length == 0 ? Container() : videoDetail(),
    );
  }

  Widget videoDetailItem(int index) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(300.0),
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
      ),
      decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(videoGroups[index].coverUrl)),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )),
      child: Container(),
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
}
