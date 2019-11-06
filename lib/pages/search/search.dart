import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';
import 'package:netease_flutter/shared/widgets/scaffold/scaffold.dart';

class NeteaseSearch extends StatefulWidget {
  @override
  _NeteaseSearchState createState() => _NeteaseSearchState();
}

class _NeteaseSearchState extends State<NeteaseSearch> {
  TextEditingController _searchController = new TextEditingController();

  dynamic _searchDefault;
  List _matchs = [];
  List<String> _history = [];

  bool _inputFocused = false;

  Widget drawIcon(String iconUrl) {
    if (iconUrl == null) {
      return Text('');
    } else {
      return Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil.getInstance().setWidth(12.0)
        ),
        child: Image.network(
          iconUrl,
          height: ScreenUtil.getInstance().setHeight(20.0),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    RequestService.getInstance(context: context).getSearchDefault().then((result) {
        print(result);
        setState(() {
          _searchDefault = result;
        });
    });
    _history = Global.mSp.getStringList('netease_chache_search_history') ?? [];
  }

  Widget searchSuggestPanel() {
    ScreenUtil screenUtil = ScreenUtil.getInstance(); 
    if (_matchs.length == 0 || !_inputFocused) {
      return Positioned(
        bottom: 0,
        height: 0,
        width: 0,
        child: Text(''),
      );
    } else {
      return Positioned(
        left: screenUtil.setWidth(35.0),
        top: screenUtil.setHeight(10.0),
        right: screenUtil.setWidth(120.0),
        height: screenUtil.setHeight(_matchs.length * 120.0),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            itemCount: _matchs.length,
            itemExtent: screenUtil.setHeight(120.0),
            itemBuilder: (BuildContext context, int index) {
              final item = _matchs[index];
              return ListTile(
                onTap: () {
                  viewSearchDetail(item['keyword']);
                },
                leading: Container(
                  width: screenUtil.setWidth(50.0),
                  child: Center(
                    child: NeteaseIconData(
                      0xe60c,
                      color: Colors.white70,
                      size: screenUtil.setSp(36.0),
                    ),
                  ),
                ),
                title: Text(
                  "${item['keyword']}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenUtil.setSp(28.0)
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return NeteaseScaffold(
      appBar: NeteaseAppBar(
        customTitle: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(101, 129, 140, 0.7),
                width: screenUtil.setHeight(1.0)
              )
            ),
            // color: Colors.tealAccent
          ),
          height: 35.0,
          margin: EdgeInsets.only(
            bottom: 5.0,
            top: 10.0
          ),
          child: TextField(
            controller: _searchController,
            onTap: () {
              setState(() {
                _inputFocused = true;
              });
            },  
            onChanged: (String text) {
              print("listen${_searchController.text.trim()}");
              if (text.trim().isNotEmpty) {
                // 查询搜索建议
                _loadSearchSuggest(text.trim());
              } else {
                setState(() {
                  _matchs = [];
                });
              }
            },
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenUtil.setSp(28.0)
            ),
            decoration: InputDecoration(
              hintText: _searchDefault == null ? "" : _searchDefault['showKeyword'],
              hintStyle: TextStyle(
                color: Theme.of(context).inputDecorationTheme.hintStyle.color,
                fontSize: screenUtil.setSp(28.0)
              ),
              border: InputBorder.none
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: NeteaseIconData(0xe60c, color: Colors.white70),
            onPressed: () {
              String keyword;
              if (_searchController.text.isEmpty) {
                keyword = _searchDefault['realkeyword'];
              } else {
                keyword = _searchController.text.trim();
              }
              viewSearchDetail(keyword);
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        overflow: Overflow.clip,
        children: <Widget>[
          Listener(
            onPointerDown: (PointerDownEvent event) {
              setState(() {
                _inputFocused = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/theme_1.jpg'),
                  fit: BoxFit.cover
                )
              ),
              height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - ScreenUtil.bottomBarHeight - 100.0,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenUtil.setWidth(30.0)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('历史记录', style: TextStyle(
                                color: Colors.white,
                                fontSize: screenUtil.setSp(28.0),
                                fontWeight: FontWeight.bold
                              )),
                              IconButton(
                                icon: NeteaseIconData(
                                  0xe67f,
                                  color: Colors.white54,
                                  size: screenUtil.setSp(36.0),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                                        title: Text(
                                          '确定清空全部历史记录？',
                                          style: TextStyle(
                                            fontSize: screenUtil.setSp(30.0)
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              '取消',
                                              style: TextStyle(
                                                fontSize: screenUtil.setSp(28.0),
                                                color: Theme.of(context).dialogTheme.titleTextStyle.color
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              '清空',
                                              style: TextStyle(
                                                fontSize: screenUtil.setSp(28.0),
                                                color: Theme.of(context).dialogTheme.titleTextStyle.color
                                              ),
                                            ),
                                            onPressed: () {
                                              Global.mSp.setStringList('netease_chache_search_history', []);
                                              setState(() {
                                                _history = [];
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                  );
                                },
                              )
                            ],
                          ),
                          Container(
                            height: screenUtil.setHeight(55.0),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: _history.map((item) {
                                return Container(
                                  width: screenUtil.setWidth(44 + item.length * 24.0),
                                  margin: EdgeInsets.only(
                                    right: screenUtil.setWidth(18.0)
                                  ),
                                  padding: EdgeInsets.zero,
                                  child: FlatButton(
                                    child: Text(item, style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: screenUtil.setSp(24.0)
                                    )),
                                    padding: EdgeInsets.zero,
                                    color: Color.fromRGBO(45, 73, 91, 0.6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      // 将此项移动到第一位
                                      _history..remove(item)..insert(0, item);
                                      Global.mSp.setStringList('netease_chache_search_history', _history);
                                      
                                      Navigator.of(context).pushNamed('search_result', arguments: item);
                                    },
                                  ),
                                );
                              }).toList()
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: screenUtil.setWidth(30.0),
                        top: screenUtil.setHeight(70.0),
                        bottom: screenUtil.setHeight(10.0)
                      ),
                      width: double.infinity,
                      child: Text(
                        '热搜榜',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenUtil.setSp(28.0)
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: RequestService.getInstance(context: context).getSearchHotDetail(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {

                        if (snapshot.hasData) {
                          List list = snapshot.data;
                          return Column(
                            children: list.asMap().keys.map((int index) {
                              var item = list[index];
                              return Material(
                                color: Colors.transparent,
                                child: ListTile(
                                  dense: true,
                                  onTap: () {
                                    viewSearchDetail(item["searchWord"]);
                                  },
                                  leading: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: index < 3 ? Theme.of(context).textSelectionColor : Colors.white70,
                                      fontSize: screenUtil.setSp(30.0),
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Text(
                                        item['searchWord'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenUtil.setSp(30.0)
                                        ),
                                      ),
                                      drawIcon(item['iconUrl'])
                                    ],
                                  ),
                                  subtitle: Text(
                                    item['content'],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: screenUtil.setSp(24.0)
                                    )
                                  ),
                                  trailing: Text(
                                    item['score'].toString(),
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: screenUtil.setSp(24.0)
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          );
                        } else {
                          return Center(
                            child: NeteaseLoading(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ),
          searchSuggestPanel()
        ],
      ),
    );
  }

  void viewSearchDetail(String keyword) {
    if (_history.contains(keyword)) {
      _history.remove(keyword);
    }
    _history.insert(0, keyword);
    Global.mSp.setStringList('netease_chache_search_history', _history);
    _inputFocused = false;
    Navigator.of(context).pushNamed('search_result', arguments: keyword);
  }

  void _loadSearchSuggest(String text) async {
    final result = await RequestService.getInstance(context: context).getSearchSuggest(text);
    setState(() {
      _matchs = result['allMatch'] ?? [];
    });
  }
}