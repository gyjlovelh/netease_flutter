import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/widgets/icon_data/icon_data.dart';

class ResultSinger extends StatefulWidget {
  final String searchWord;
  ResultSinger({@required this.searchWord});

  @override
  _ResultSingerState createState() => _ResultSingerState();
}

class _ResultSingerState extends State<ResultSinger> {
  final int _limit = 20;
  int _offset = 0;
  bool _hasMore = true; // 是否已经到底.

  ScrollController _controller;
  List _singers = List();
  int _singerCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_offset + _limit > _singerCount) {
          // 已经到底了
          _hasMore = false;
        } else {
          _offset += _limit;
          _loadMore();        
        }
      }
    });
    _loadMore();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      child: Container(
        height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
        child: ListView(
          itemExtent: screenUtil.setHeight(120.0),
          controller: _controller,
          children: _singers.map((item) {

            return ListTile(
              onTap: () {
                
              },
              leading: Container(
                height: screenUtil.setHeight(90.0),
                width: screenUtil.setHeight(90.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      item['img1v1Url']
                    ),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(999.0)
                ),
              ),
              title: Text(item['name'], style: TextStyle(
                color: Colors.black87,
                fontSize: screenUtil.setSp(28.0)
              )),
              trailing: Container(
                width: screenUtil.setWidth(180.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: screenUtil.setWidth(10.0)
                      ),
                      padding: EdgeInsets.all(screenUtil.setWidth(8.0)),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(999.0)
                      ),
                      child: NeteaseIconData(
                        0xe68e,
                        color: Colors.white,
                        size: screenUtil.setSp(20.0),
                      ),
                    ),
                    Text('已入驻')
                  ],
                ),
              ),
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _loadMore() async {
    var response = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.searchWord,
      type: 100,
      limit: _limit,
      offset: _offset
    );

    setState(() {
      _singers.addAll(response['artists']);
      _singerCount = response['artistCount'];
    });
  }
}