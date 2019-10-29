import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';

class NeteaseUser extends StatefulWidget {
  @override
  _NeteaseUserState createState() => _NeteaseUserState();
}

class _NeteaseUserState extends State<NeteaseUser> with SingleTickerProviderStateMixin {

  TabController _tabController;
  LoadingStatus status = LoadingStatus.UNINIT;

  ProfileModel _profile;

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
                    image: NetworkImage("${_profile.backgroundUrl}"),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  height: screenUtil.setHeight(300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ClipOval(
                        child: Image.network(
                          "${_profile.avatarUrl}",
                          height: screenUtil.setWidth(150.0),
                          width: screenUtil.setWidth(150.0),
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
                                Text('${_profile.nickname}'),
                                Text('粉丝/关注'),
                                Text('等级')
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: Container(
                              width: screenUtil.setWidth(280.0),
                              child: Row(
                                children: <Widget>[
                                  RaisedButton.icon(
                                    icon: Icon(Icons.add),
                                    label: Text('关注'),
                                    onPressed: () {},
                                  ),
                                  RaisedButton.icon(
                                    icon: Icon(Icons.message),
                                    label: Text('发私信'),
                                    onPressed: () {},
                                  ),
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
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Center(child: Text('Content of Home')),
                Center(child: Text('Content of Profile')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadPageData() async {
    int userId = ModalRoute.of(context).settings.arguments;
    final result = await RequestService.getInstance(context: context).getUserDetail(userId);

    setState(() {
      status = LoadingStatus.LOADED;
     _profile = ProfileModel.fromJson(result['profile']);
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