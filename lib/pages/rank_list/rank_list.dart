import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteaseRankList extends StatefulWidget {
  @override
  _NeteaseRankListState createState() => _NeteaseRankListState();
}

class _NeteaseRankListState extends State<NeteaseRankList> {
  List _list = [];

  @override
  void initState() {
    super.initState();

    _initPageData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    //官方榜
    List officialRankWidgets = _list.where((item) => item['tracks'] != null && item['tracks'].length > 0).toList();
    
    // 其他榜
    List otherRank = _list.where((item) => item['tracks'] == null || item['tracks'].length == 0).toList();

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        title: '排行榜',
      ),
      body: Container(
        height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100.0,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.symmetric(
                // vertical: screenUtil.setHeight(28.0),
                horizontal: screenUtil.setWidth(30.0)
              ),
              sliver: new SliverFixedExtentList(
                itemExtent: screenUtil.setHeight(150.0),
                delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                    //创建列表项      
                  return new Container(
                    alignment: Alignment.bottomLeft,
                    child: new Text('官方榜', style: TextStyle(
                      fontSize: screenUtil.setSp(32.0),
                      fontWeight: FontWeight.bold
                    )),
                  );
                }, childCount: 1),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                final item = officialRankWidgets[index];
                return ListTile(
                  onTap: () {},
                  onLongPress: () {},
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      rankCover(item),
                      Padding(
                        padding: EdgeInsets.only(left: screenUtil.setWidth(20.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (item['tracks'] as List).cast().asMap().keys.map((key) {
                            var track = item['tracks'][key];
                            String index = (key + 1).toString();
                            String fName = track['first'];
                            String sName = track['second'];
                            return Container(
                              width: screenUtil.setWidth(450.0),
                              child: Text("$index.$fName - $sName", 
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenUtil.setSp(28.0)
                                )
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  )
                );
              }, childCount: officialRankWidgets.length),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                // vertical: screenUtil.setHeight(28.0),
                horizontal: screenUtil.setWidth(30.0)
              ),
              sliver: new SliverFixedExtentList(
                itemExtent: screenUtil.setHeight(150.0),
                delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                    //创建列表项      
                  return new Container(
                    alignment: Alignment.bottomLeft,
                    child: new Text('其他榜单', style: TextStyle(
                      fontSize: screenUtil.setSp(32.0),
                      fontWeight: FontWeight.bold
                    )),
                  );
                }, childCount: 1),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: screenUtil.setHeight(28.0),
                horizontal: screenUtil.setWidth(30.0)
              ),
              sliver: SliverGrid.count(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                mainAxisSpacing: screenUtil.setWidth(12.0),
                crossAxisSpacing: screenUtil.setWidth(5.0),
                children: otherRank.map((item) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(screenUtil.setWidth(8.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          rankCover(item),
                          Text(item['name'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenUtil.setSp(20.0)
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        )
      )
    );
  }

  Widget rankCover(item) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return Container(
      width: screenUtil.setWidth(220.0),
      height: screenUtil.setWidth(220.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(item['coverImgUrl']),
          fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.circular(
          screenUtil.setWidth(12.0)
        )
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: screenUtil.setWidth(12.0),
            bottom: screenUtil.setHeight(12.0)
          ),
          child: Text(item['updateFrequency'], style: TextStyle(
            color: Colors.white,
            fontSize: screenUtil.setSp(22.0)
          )),
        ),
      )
    );
  }

  void _initPageData() async {
    List list = await RequestService.getInstance(context: context).getToplistDetail();

    setState(() {
      _list = list;
    });
  }
}