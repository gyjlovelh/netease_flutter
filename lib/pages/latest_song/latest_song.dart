import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/pages/latest_song/panel_item.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteaseLatestSong extends StatefulWidget {
  @override
  _NeteaseLatestSongState createState() => _NeteaseLatestSongState();
}

class _NeteaseLatestSongState extends State<NeteaseLatestSong> with SingleTickerProviderStateMixin {

  TabController tabController;

  List tabs = [];

  @override
  void initState() {
    super.initState();
    tabs..add({"label": "推荐", "type": 0})
      ..add({"label": "华语", "type": 7})
      ..add({"label": "欧美", "type": 96})
      ..add({"label": "韩国", "type": 16})
      ..add({"label": "日本", "type": 8});
    tabController = new TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: "最新音乐",
      ),
      tabbar: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).textSelectionColor,
        unselectedLabelColor: Colors.white70,
        tabs: tabs.map((item) => Text("${item['label']}")).toList(),
      ),
      body: Container(
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 130.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/theme_1.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: TabBarView(
          controller: tabController,
          children: tabs.map((item) => new PanelItem(label: item['label'], type: item['type'],)).toList(),
        ),
      ),
    );
  }
}