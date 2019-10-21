import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';

class ResultAlbum extends StatefulWidget {

  final String searchWord;
  ResultAlbum({@required this.searchWord});

  @override
  _ResultAlbumState createState() => _ResultAlbumState();
}

class _ResultAlbumState extends State<ResultAlbum> {
  final int _limit = 20;
  int _offset = 0;
  bool _hasMore = true; // 是否已经到底.

  List _albumList = List();
  int _albumCount = 0;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (_offset + _limit > _albumCount) {
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
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();

    return SingleChildScrollView(
      child: Container(
        height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
        child: ListView(
          controller: _controller,
          itemExtent: screenUtil.setHeight(120.0),
          children: _albumList.map((item) {

            return ListTile(
              leading: Container(
                height: screenUtil.setHeight(90.0),
                width: screenUtil.setHeight(90.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item['picUrl']),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(screenUtil.setWidth(8.0))
                ),
                // child: ,
              ),
              title: Text(item['name'], style: TextStyle(
                fontSize: screenUtil.setSp(28.0),
                color: Colors.black87
              )),
              subtitle: Text(item['artist']['name'], style: TextStyle(
                fontSize: screenUtil.setSp(22.0)
              )),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _loadMore() async {
    var response = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.searchWord,
      type: 10,
      limit: _limit,
      offset: _offset
    );

    print(response['albums']);

    setState(() {
      _albumList.addAll(response['albums']);
      _albumCount = response['albumCount'];
    });
  }
}