import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/widgets/player/player.dart';


class NeteaseScaffold extends StatefulWidget {
  final Widget body;
  final NeteaseAppBar appBar;
  final TabBar tabbar;
  final Widget customFooter;
  // final bool showPlayer;

  NeteaseScaffold({
    @required this.body,
    @required this.appBar,
    this.tabbar,
    this.customFooter
  });

  @override
  _NeteaseScaffoldState createState() => _NeteaseScaffoldState();
}

class _NeteaseScaffoldState extends State<NeteaseScaffold> {
  @override
  Widget build(BuildContext context) {
    // 默认背景色
    Color backgroundColor;

    double tabBarHeight = 0;
    List<Widget> contents = [];

    if (widget.appBar.backgroundColor != null) {
      backgroundColor = widget.appBar.backgroundColor;
    }
    // 当拥有tabbar时，appbar默认为不透明
    if (widget.tabbar != null) {
      tabBarHeight = 30.0;
    }

    ///内容区域
    Widget mainW = Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: ScreenUtil.bottomBarHeight,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///内容区域顶部留白
            Container(
              height: ScreenUtil.statusBarHeight + 50.0 + tabBarHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
            ),
            ///用户可视内容区域
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100.0 - tabBarHeight
              ),
              child: widget.body,
            ),
            ///底部抵消播放条高度
            Container(
              height: 50.0,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
    ///顶部刘海
    Widget statusBarW = Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: ScreenUtil.statusBarHeight,
      child: Container(
        color: backgroundColor,
      ),
    );
    ///自定义AppBar
    Widget customAppBarW = Positioned(
      left: 0,
      right: 0,
      top: ScreenUtil.statusBarHeight,
      height: 50.0,
      child: Container(
        color: backgroundColor.withOpacity(0.2),
        child: widget.appBar ?? new NeteaseAppBar(title: "Netease_Flutter"),
      ),
    );
    contents..add(mainW)..add(statusBarW)..add(customAppBarW);
    ///TabBar
    if (widget.tabbar != null) {
      Widget customTabBarW = Positioned(
        left: 0,
        right: 0,
        top: ScreenUtil.statusBarHeight + 50.0,
        height: tabBarHeight,
        child: Container(
          color: backgroundColor,
          child: widget.tabbar
        ),
      );
      contents.add(customTabBarW);
    }
    ///音乐播放条
    Widget playerW = Positioned(
      left: 0,
      right: 0,
      bottom: ScreenUtil.bottomBarHeight,
      height: 50.0,
      child: widget.customFooter ?? new NeteasePlayer(),
    );
    contents.add(playerW);
    
    
    
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand,
          children: contents
        ),
      ),
    );
  }
}


class NeteaseAppBar extends StatelessWidget {
  final String title;
  final Widget customTitle;
  final String subtitle;
  final Color backgroundColor;
  final List<Widget> actions;

  NeteaseAppBar({
    this.title,
    this.customTitle,
    this.subtitle,
    this.backgroundColor = const Color.fromRGBO(44, 66, 82, 1),
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    List<Widget> rowItems = [];
    List<Widget> contents = [];

    if (customTitle != null) {
      contents.add(customTitle);
    } else {
      ///解析title和subtitle
      Widget titleW = Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0
        ),
      );
      contents.add(titleW);

      if (subtitle != null && subtitle.isNotEmpty) {
        contents.add(Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10.0
          ),
        ));
      }
    }
    
    ///返回键
    rowItems.add(Expanded(
      flex: 0,
      child: Container(
        width: screenUtil.setWidth(120.0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
        ),
      ),
    ));
    ///content
    rowItems.add(Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: contents,
      ),
    ));

    if (actions != null && actions.length > 0) {
      rowItems.add(Expanded(
        flex: 0,
        child: Row(
          children: actions,
        ),
      ));
    }

    return Container(
      color: backgroundColor,
      child: Flex(
        direction: Axis.horizontal,
        children: rowItems
      )
    );
  }

}