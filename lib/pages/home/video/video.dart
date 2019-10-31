import 'package:flutter/material.dart';
import '../../../shared/service/request_service.dart';
import '../../../models/video_group_list.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {

  List<VideoGroupListModel> videoGroupList = List<VideoGroupListModel>();

  @override
  Widget build(BuildContext context) {

    RequestService request = RequestService.getInstance(context: context);
    request.getVideoGroupList().then((val){
      print('getVideoGroupList 返回的数据 : '+val.toString());
      videoGroupList.clear();
      var list = val['data'] as List;
      videoGroupList = list.map((i){
        return VideoGroupListModel.fromJson(i);
      }).toList();
      print('videoGroupList.length = '+videoGroupList.length.toString());
    });

    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal, 
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(videoGroupList[index].name),
          );
        },
      ),
    );
  }
}