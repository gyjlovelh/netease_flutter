import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/play_record/record_list.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteasePlayRecord extends StatefulWidget {
  @override
  _NeteasePlayRecordState createState() => _NeteasePlayRecordState();
}

class _NeteasePlayRecordState extends State<NeteasePlayRecord> with SingleTickerProviderStateMixin {

  LoadingStatus status = LoadingStatus.UNINIT;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    final arguments = json.decode(ModalRoute.of(context).settings.arguments);

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: "${arguments['nickname']}的听歌排行",
      ),
      tabbar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).textSelectionColor,
        unselectedLabelColor: Colors.white70,
        tabs: <Widget>[
          Text('最近一周'),
          Text('所有时间')
        ],
      ),
      body: Container(
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight- 100 - 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme_1.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            new RecordList(userId: arguments['userId'], type: 1),
            new RecordList(userId: arguments['userId'], type: 0),
          ],
        ),
      ),
    );
  }
}