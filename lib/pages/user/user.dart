import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';

import 'user_home.dart';

class NeteaseUser extends StatefulWidget {
  @override
  _NeteaseUserState createState() => _NeteaseUserState();
}

class _NeteaseUserState extends State<NeteaseUser> with SingleTickerProviderStateMixin {

  TabController _tabController;
  LoadingStatus status = LoadingStatus.UNINIT;

  ProfileModel _profile;
  int _listenSongs = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 扁平按钮
  Widget flatIconButton(int pointer, {
    String label,
    double width,
    Color color,
    VoidCallback onPressed
  }) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      width: screenUtil.setWidth(width),
      height: screenUtil.setHeight(60.0),
      padding: EdgeInsets.all(0),
      child: RaisedButton(
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: screenUtil.setWidth(16.0),
                right: screenUtil.setWidth(16.0)
              ),
              child: NeteaseIconData(
                pointer,
                color: Colors.white70,
                size: screenUtil.setSp(25.0),
              ),
            ),
            Text(
              '$label',
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenUtil.setSp(20.0)
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99.0)
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget getContent(Widget content) {
    if (_profile == null) {
      return Center(
        child: NeteaseLoading(),
      );
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    if (status == LoadingStatus.UNINIT) {
      _loadPageData();
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0,
            expandedHeight: screenUtil.setHeight(500.0),
            flexibleSpace: FlexibleSpaceBar(
              // title: Text('${_profile.nickname}'),
              centerTitle: false,
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("${_profile?.backgroundUrl}"),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenUtil.setWidth(40.0)
                  ),
                  height: screenUtil.setHeight(300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: screenUtil.setHeight(50.0)
                        ),
                        child: ClipOval(
                          child: Image.network(
                            "${_profile?.avatarUrl}",
                            height: screenUtil.setWidth(170.0),
                            width: screenUtil.setWidth(170.0),
                          ),
                        ),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${_profile?.nickname}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenUtil.setSp(30.0),
                                    shadows: [
                                      Shadow(
                                        color: Theme.of(context).textSelectionColor,
                                        blurRadius: screenUtil.setWidth(5.0)
                                      )
                                    ]
                                  ),
                                ),
                                Text(
                                  '关注 ${_profile?.follows} | 粉丝 ${_profile?.followeds}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: screenUtil.setSp(24.0),
                                    shadows: [
                                      Shadow(
                                        color: Theme.of(context).textSelectionColor,
                                        blurRadius: screenUtil.setWidth(5.0)
                                      )
                                    ]
                                  ),
                                ),
                                Text('等级')
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              width: screenUtil.setWidth(300.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: screenUtil.setWidth(10.0)),
                                    child: flatIconButton(
                                      0xe60f,  //  todo 图标大小有问题
                                      label: '关注', 
                                      width: 120.0,
                                      color: Theme.of(context).textSelectionColor,
                                      onPressed: () {

                                      }
                                    ),
                                  ),
                                  flatIconButton(
                                    0xe60f, 
                                    label: '发私信', 
                                    width: 145.0,
                                    color: Colors.black38,
                                    onPressed: () {}
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: StickyTabBarDelegate(
              child: TabBar(
                labelColor: Theme.of(context).textSelectionColor,
                unselectedLabelColor: Colors.white70,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text: '主页'),
                  Tab(text: '动态'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/theme_1.jpg"),
                  fit: BoxFit.cover
                )
              ),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  getContent(new UserHome(profile: _profile, listenSongs: _listenSongs)),
                  getContent(Center(child: Text('Content of Profile'))),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  void _loadPageData() async {
    setState(() {
      status = LoadingStatus.LOADING;
    });
    int userId = ModalRoute.of(context).settings.arguments;
    final result = await RequestService.getInstance(context: context).getUserDetail(userId);
    setState(() {
      status = LoadingStatus.LOADED;
     _profile = ProfileModel.fromJson(result['profile']);
     _listenSongs = result['listenSongs'];
    });
  }
}


class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;
 
  StickyTabBarDelegate({@required this.child});
 
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }
 
  @override
  double get maxExtent => this.child.preferredSize.height;
 
  @override
  double get minExtent => this.child.preferredSize.height;
 
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}