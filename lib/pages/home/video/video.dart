import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/service/request_service.dart';
import '../../../models/video_group_list.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<VideoGroupListModel> videoGroupList = List<VideoGroupListModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 10, vsync: this);
  }

  void setVideoGroupListData(BuildContext context) {
    RequestService request = RequestService.getInstance(context: context);
    request.getVideoGroupList().then((val) {
      print('getVideoGroupList 返回的数据 : ' + val.toString());
      videoGroupList.clear();
      var list = val['data'] as List;
      videoGroupList = list.map((i) {
        return VideoGroupListModel.fromJson(i);
      }).toList();
      print('videoGroupList.length = ' + videoGroupList.length.toString());
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Widget> setTabs() {
    List<Widget> tabs = List<Widget>();
    for (int i = 0; i < 10; i++) {
      tabs.add(
        Container(
            margin: EdgeInsets.all(20.0),
            child: Text(
              videoGroupList[i].name,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.getInstance().setSp(28.0),
              ),
            )),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    setVideoGroupListData(context);

    return 
    DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: null,
          actions: null,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(color: Colors.red),
            tabs: setTabs(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
            Container(
              child: Text('视频详情页'),
            ),
          ],
        ),
      ),
    );

    // Container(
    //   child: DefaultTabController(
    //     length: 10,
    //     child: Column(
    //       children: <Widget>[
    //         TabBar(
    //           isScrollable: true,
    //           labelColor: Colors.red,
    //           tabs: setTabs(),
    //         ),
    //         TabBarView(
    //           controller: _tabController,
    //           children: <Widget>[
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //             Container(child: Text('视频详情页'),),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
