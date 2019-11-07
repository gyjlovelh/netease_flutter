import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'custom_drawer.dart';
import '../../../shared/widgets/icon_data/icon_data.dart';

class NeteaseDrawer extends StatefulWidget {
  @override
  _NeteaseDrawerState createState() => _NeteaseDrawerState();
}

class _NeteaseDrawerState extends State<NeteaseDrawer> {

  // 抽提菜单宽度
  final double drawerWidth = ScreenUtil.getInstance().setWidth(615.0);
  // 水平方向间距
  final double horizontalWidth = ScreenUtil.getInstance().setWidth(28.0);

  Widget bottomAction({int pointer, String label, onPressed}) => Container(
    height: ScreenUtil.getInstance().setHeight(100.0),
    child: FlatButton.icon(
      icon: NeteaseIconData(pointer, color: Colors.white70, size: ScreenUtil.getInstance().setSp(36.0),),
      label: Text(label, style: TextStyle(
        color: Colors.white70,
        fontSize: SizeSetting.size_14
      )),
      onPressed: onPressed
    ),
  );

  Widget iconAndMessage({int pointer, String label, onPressed}) => Container(
    width: ScreenUtil.getInstance().setWidth(138.0),
    child: FlatButton(
      onPressed: () {},
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: NeteaseIconData(
              pointer, 
              color: Theme.of(context).textSelectionColor,
              size: ScreenUtil.getInstance().setSp(42.0)
            )
          ),
          Container(
            child: Text(label, style: TextStyle(
              color: Colors.white70,
              fontSize: SizeSetting.size_12
            )),
          )
        ],
      ),
    )
  );

  Widget listTiles() {
    List tiles = List();
    tiles..add({"pointer": 0xe61a, "title": "演出", "trailing": "马克西姆"})
      ..add({"pointer": 0xe622, "title": "商城", "trailing": "先锋耳机5折"})
      ..add({"pointer": 0xe659, "title": "附近的人"})
      ..add({"pointer": 0xe6d8, "title": "口袋彩铃"})
      ..add({"isDivider": true})
      ..add({"pointer": 0xe739, "title": "创作者中心"})
      ..add({"isDivider": true})
      ..add({"pointer": 0xe603, "title": "我的订单"})
      ..add({"pointer": 0xe662, "title": "定时停止播放"})
      ..add({"pointer": 0xe600, "title": "扫一扫"})
      ..add({"pointer": 0xe607, "title": "音乐闹钟"})
      ..add({"pointer": 0xe7da, "title": "音乐云盘"})
      ..add({"pointer": 0xe657, "title": "在线听歌免流量", "trailing": "已开通"})
      ..add({"pointer": 0xe822, "title": "优惠券"})
      ..add({"pointer": 0xe602, "title": "青少年模式", "trailing": "未开启"});

    return Column(
      
      children: tiles.map((item) {
        if (item["isDivider"] == true) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalWidth),
            child: Divider(height: ScreenUtil.getInstance().setHeight(28.0)),
          );
        } else {
          return Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Padding(
                padding: EdgeInsets.only(left: horizontalWidth),
                child: NeteaseIconData(
                  item["pointer"],
                  color: Colors.white70,
                  size: ScreenUtil.getInstance().setSp(32.0),
                ),
              ),
              dense: true,
              // selected: true,
              onTap: () {},
              contentPadding: EdgeInsets.all(0.0),
              title: Text(item["title"], style: TextStyle(
                color: Colors.white70,
                fontSize: SizeSetting.size_12
              )),
              trailing: Padding(
                padding: EdgeInsets.only(right: horizontalWidth),
                child: Text(item["trailing"] ?? "", style: TextStyle(
                  color: Colors.white54,
                  fontSize: SizeSetting.size_8
                ),),
              )
            ),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil screenUtil = ScreenUtil.getInstance();
    ProfileModel profile = Global.profile;

    return CustomDrawer(
      width: drawerWidth,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalWidth,
                  vertical: 30.0
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/theme_1.jpg'),
                    fit: BoxFit.cover
                  )
                ),
                width: double.infinity,
                height: screenUtil.setHeight(420.0),
                // color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.network(
                            "${profile?.avatarUrl}",
                            fit: BoxFit.cover,
                            height: screenUtil.setWidth(150.0),
                            width: screenUtil.setWidth(150.0),
                          )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: horizontalWidth,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${profile?.nickname}", 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeSetting.size_16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: screenUtil.setWidth(12.0)
                            ),
                            height: screenUtil.setHeight(36.0),
                            width: screenUtil.setWidth(70.0),
                            child: FlatButton(
                              onPressed: () {},
                              color: Theme.of(context).textSelectionColor,
                              textColor: Colors.white70,
                              padding: EdgeInsets.zero,
                              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(99.0)),
                              child: Text(
                                // todo 暂时还没取值等级。先用其他代替
                                'Lv.${profile?.vipType}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeSetting.size_8,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: horizontalWidth),
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalWidth
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          iconAndMessage(pointer: 0xe60f, label: '我的消息'),
                          iconAndMessage(pointer: 0xe68e, label: '我的好友'),
                          iconAndMessage(pointer: 0xe601, label: '听歌识曲'),
                          iconAndMessage(pointer: 0xe629, label: '个性装扮'),
                        ],
                      )
                    ),
                    Divider(height: screenUtil.setHeight(68.0)),
                    listTiles()
                  ],
                ),
              ),
              Container(
                height: screenUtil.setHeight(100.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: screenUtil.setHeight(1.0),
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  color: Theme.of(context).primaryColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    bottomAction(
                      pointer: 0xe615,
                      label: '夜间模式',
                      onPressed: () {}
                    ),
                    bottomAction(
                      pointer: 0xe675,
                      label: '设置',
                      onPressed: () {}
                    ),
                    bottomAction(
                      pointer: 0xe74d,
                      label: '退出',
                      onPressed: () async {
                        await Global.mSp.remove('netease_cache_profile');
                        Navigator.of(context).pushNamed('login');
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}