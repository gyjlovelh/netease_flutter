import 'package:flutter/material.dart';
import '../../shared/widgets/icon_data/icon_data.dart';

class LocalMusics extends StatefulWidget {
  @override
  _LocalMusicsState createState() => _LocalMusicsState();
}

class _LocalMusicsState extends State<LocalMusics>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Icon(
              Icons.backspace,
              color: Colors.black,
            ),
            title: Text('本地音乐',style: TextStyle(color: Colors.black),),
            actions: <Widget>[
              IconButton(
                icon: NeteaseIconData(
                  0xe60c,
                  color: Colors.black,
                ),
                onPressed: () {
                  //todo 跳转到搜索界面
                },
              ),
              // IconButton(
              //   icon: NeteaseIconData(
              //     0xe62b,
              //     color: Colors.black,
              //   ),
              //   onPressed: () {},
              // ),
              PopupMenuButton(
                icon: Icon(Icons.more,color: Colors.black,),
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem(child: Text('扫描本地音乐'),),
                  PopupMenuItem(child: Text('选择排序方式'),),
                  PopupMenuItem(child: Text('获取封面歌词'),),
                  PopupMenuItem(child: Text('升级音质'),)
                ],
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text('单曲'),
                ),
                Tab(
                  child: Text('歌手'),
                ),
                Tab(
                  child: Text('专辑'),
                ),
                Tab(
                  child: Text('文件夹'),
                ),
              ],
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Text('单曲'),
              Text('歌手'),
              Text('专辑'),
              Text('文件夹'),
            ],
          ),
        ),
      ),

      // Scaffold(
      //   appBar: AppBar(
      //     backgroundColor: Colors.white,
      //     leading: Icon(Icons.backspace),
      //     title: Text('本地音乐'),
      //     actions: <Widget>[
      //       IconButton(
      //         icon: NeteaseIconData(0xe60c),
      //         onPressed: () {
      //           //todo 跳转到搜索界面
      //         },
      //       ),
      //       IconButton(
      //         icon: NeteaseIconData(0xe62b),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      //   body: MaterialApp(
      //     home: DefaultTabController(
      //       length: 4,
      //       child: TabBar(
      //         tabs: <Widget>[
      //           Tab(
      //             child: Text('单曲'),
      //           ),
      //           Tab(
      //             child: Text('歌手'),
      //           ),
      //           Tab(
      //             child: Text('专辑'),
      //           ),
      //           Tab(
      //             child: Text('文件夹'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
