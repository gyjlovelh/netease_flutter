import 'package:flutter/material.dart';
import '../../../models/video_group_1.dart';
import '../../../shared/service/request_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/loading/loading.dart';

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

  _VideoDetailState({@required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RequestService.getInstance(context: context).getVideoGroup(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          videoGroups.clear();
          List list = snapshot.data['datas'] as List;
          for(int i = 0;i < list.length;i++) {
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
          print('视频 videoGroups.length = '+videoGroups.length.toString());
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
    return Container(
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
        borderRadius: BorderRadius.circular(ScreenUtil.instance.setWidth(20.0)),
      ),
      child: Container(
        
      ),
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
