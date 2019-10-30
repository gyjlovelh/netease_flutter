import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

import 'playlist_list.dart';

class NeteasePlaylistOfUser extends StatefulWidget {
  @override
  _NeteasePlaylistOfUserState createState() => _NeteasePlaylistOfUserState();
}

class _NeteasePlaylistOfUserState extends State<NeteasePlaylistOfUser> with SingleTickerProviderStateMixin {

  LoadingStatus status = LoadingStatus.UNINIT;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);

  }

  @override
  Widget build(BuildContext context) {
    final arguments = json.decode(ModalRoute.of(context).settings.arguments);
    
    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: "${arguments['nickname']}的歌单",
      ),
      tabbar: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).textSelectionColor,
        unselectedLabelColor: Colors.white70,
        tabs: <Widget>[
          Text("创建的歌单"),
          Text('收藏的歌单')
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/theme_1.jpg'),
            fit: BoxFit.cover
          ),
        ),
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100 -50,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            new PlaylistList(userId: arguments['userId'], isCreator: true),
            new PlaylistList(userId: arguments['userId'], isCreator: false),
          ],
        ),
      ),
    );
  }
}