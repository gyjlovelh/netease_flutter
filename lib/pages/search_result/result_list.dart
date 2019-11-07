import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_flutter/shared/enums/loading_status.dart';
import 'package:netease_flutter/shared/service/request_service.dart';
import 'package:netease_flutter/shared/states/global.dart';
import 'package:netease_flutter/shared/states/size_setting.dart';
import 'package:netease_flutter/shared/widgets/loading/loading.dart';

typedef ResultBuilder = Widget Function(dynamic item);

class ResultList extends StatefulWidget {
  final String keyword;
  final int type;
  final String listKey;
  final String countKey;
  final ResultBuilder itemBuilder;
  const ResultList({
    @required this.type,
    @required this.keyword,
    @required this.listKey,
    @required this.countKey,
    @required this.itemBuilder
  });

  @override
  _ResultListState createState() => _ResultListState();
}


class _ResultListState extends State<ResultList> {
  int _limit = 20;
  int _offset = 0;
  bool _hasMore = true; // 是否已经到底.
  LoadingStatus status = LoadingStatus.UNINIT;

  List _resultList = [];
  int _resultCount = 0;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // 已经下拉到最底部
        print('============================ 到底了。。。 ============================');
        if (status == LoadingStatus.LOADING) return; 
        _offset += 30;
        _loadMore();  
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
    
    List<Widget> _contents = [];
    if (status == LoadingStatus.UNINIT) {
      return Center(child: NeteaseLoading());
    } else {
      _contents.addAll(_resultList.map((item) => widget.itemBuilder(item)).toList());
      if (_hasMore) {
        if (status == LoadingStatus.LOADING) {
          _contents.add(ListTile(
            title: NeteaseLoading(),
          ));
        } 
      } else {
        _contents.add(ListTile(
          title: Text(
            '- 到底了 -',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: SizeSetting.size_14
            ),
          ),
        ));
      }
    }
    
    return SingleChildScrollView(
      child: Container(
        height: screenUtil.setHeight(Global.MAIN_SCALE * screenUtil.height),
        child: ListView(
          controller: _controller,
          padding: EdgeInsets.only(bottom: 50 + screenUtil.setHeight(60.0)),
          itemExtent: screenUtil.setHeight(120.0),
          children: _contents
        ),
      ),
    );
  }

  void _loadMore() async {
    setState(() {
      status = LoadingStatus.LOADING;
    });
    var response = await RequestService.getInstance(context: context).getSearchResult(
      keywords: widget.keyword,
      type: widget.type,
      limit: _limit,
      offset: _offset
    );

    if (mounted) {
      setState(() {
        status = LoadingStatus.LOADED;
        if (_resultList == null || response == null) return; 
        _resultList.addAll(response["${widget.listKey}"]);
        _resultCount = response["${widget.countKey}"];
        if (_offset + _limit >= _resultCount) {
          _hasMore = false;
        }
      });
    }
  }
}