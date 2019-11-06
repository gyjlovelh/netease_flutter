import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/playlist.dart';
import '../../shared/states/global.dart';

class RequestService {
  static Dio _dio;

  static String _baseUrl;

  static BuildContext _context;

  static RequestService _instance;

  SharedPreferences _sp = Global.mSp;

  static init({String baseUrl}) {
    _baseUrl = baseUrl;
    _dio = new Dio();
    _dio.options.receiveTimeout = 10000;
    _dio.options.connectTimeout = 10000;
    _dio.interceptors.add(CookieManager(CookieJar()));

    _dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) {
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    }, onError: (DioError e) {
      return e;
    }));
  }

  static RequestService getInstance({@required BuildContext context}) {
    _context = context;
    if (_baseUrl.isEmpty) {
      print('必须对RequestService进行初始化操作');
      throw new Error();
    }
    if (_instance == null) {
      _instance = new RequestService._();
    }
    return _instance;
  }

  RequestService._();

  Future<Response<T>> _request<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      return await _dio.post(_baseUrl + path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
    } on DioError catch (error) {
      // 弹框
      print("$error");
      return error.response;
    }
    
  }

  /*
   * 手机号登录
   */
  Future<ProfileModel> login({String phone, String password}) async {
    Response response = await _request('/login/cellphone',
        queryParameters: {"phone": phone, "password": password});

    return ProfileModel.fromJson(response.data['profile']);
  }

  /*
   * 轮播图数据
   */
  Future<List> getBanner() async {
    Response response = await _request('/banner', queryParameters: {"type": 2});

    return response.data['banners'];
  }

  // 获取每日推荐歌曲
  Future getRecommendSongs() async {
    Response response = await _request('/recommend/songs?timestamp=${DateTime.now().microsecondsSinceEpoch}');
    List songs = response.data['recommend'] ?? [];
    List songIds = songs.map((item) => item['id']).toList();
    Response urlRes = await _request('/song/url', queryParameters: {"id": songIds.join(',')});
    List urls = urlRes.data['data'];

    // 歌曲url不是按顺序返回
    songs.asMap().forEach((int index, var item) {
      final target = urls.firstWhere((urlItem) => urlItem['id'] == item['id']);
      item['url'] = target['url'];
    });   
    return songs;
  }

  // 获取推荐歌单
  Future<List> getRecommendPlaylist() async {
    Response response = await _request('/personalized', queryParameters: {"limit": 6});
    return response.data['result'];
  }

  // 私人FM
  Future<List> getPersonalFm() async {
    Response response = await _request('/personal_fm?timestamp=${DateTime.now().microsecondsSinceEpoch}');
    List songs = response.data['data'] ?? [];
    List songIds = songs.map((item) => item['id']).toList();
    Response urlRes = await _request('/song/url', queryParameters: {"id": songIds.join(',')});
    List urls = urlRes.data['data'];

    // 歌曲url不是按顺序返回
    songs.asMap().forEach((int index, var item) {
      final target = urls.firstWhere((urlItem) => urlItem['id'] == item['id']);
      item['url'] = target['url'];
    });   
    return songs;
  }

  // 获取歌曲详情
  Future<SongModel> getSongDetail(int id) async {
    Response response =
        await _request('/song/detail', queryParameters: {"ids": id});
    Response urlRes = await _request('/song/url', queryParameters: {"id": id});
    SongModel song = SongModel.fromJson(response.data['songs'][0]);
    song.url = urlRes.data['data'][0]['url'];

    return song;
  }

  // 喜欢音乐
  Future addSongToFavourite(int id, {bool like = true}) async {
    Response response = await _request('/like', queryParameters: {"id": id, "like": like});

    return response.data;
  }

  // 音乐是否可用【全部都没版权？？？】
  Future checkMusic(int id) async {
    try {
      print("$id");
      Response response = await _request('/check/music',
          queryParameters: {"id": id, "br": 320000});

      return response.data;
    } on DioError catch (error) {
      return error.response;
    }
  }

  // 获取歌曲歌词
  Future<List> getSongLyric(int id) async {
    Response response = await _request('/lyric', queryParameters: {"id": id});
    if (response.data != null && response.data['lrc'] != null) {
      // 原有语言歌词
      String lyric = response.data['lrc']['lyric'];
      List<String> lines = lyric.split('\n');
      RegExp pattern = new RegExp(r"\[\d{2}:\d{2}.\d{1,3}\]");
      List temp = List();
      List result = List();

      lines.forEach((line) {
        if (pattern.hasMatch(line)) {
          temp.add(line);
        }
      });

      temp.forEach((line) {
        String time =
            pattern.stringMatch(line).replaceAll(new RegExp(r'\[|\]'), '');

        List<String> times = time.split('.')[0].split(':');
        int minute = int.parse(times[0]);
        int second = int.parse(times[1]);
        int milliseconds = int.parse(time.split('.')[1]);

        String word = line.replaceAll(pattern, '');
        result.add({
          "time": time, 
          "lyric": word, 
          "second": minute * 60 + second, 
          "milliseconds": milliseconds + (minute * 60 + second) * 1000
        });
      });
      return result;
    }
    return [];
  }

  // 获取歌单详情
  Future<PlaylistModel> getPlaylistDetail(int id) async {
    Response response =
        await _request('/playlist/detail', queryParameters: {"id": id});
    PlaylistModel model = PlaylistModel.fromJson(response.data['playlist']);
    String trackIds = model.tracks.map((item) => item.id).join(',');
    Response urlRes =
        await _request('/song/url', queryParameters: {"id": trackIds});
    List list = urlRes.data['data'];

    // 歌曲url不是按顺序返回
    model.tracks.asMap().forEach((int index, SongModel item) {
      final target = list.firstWhere((song) => song['id'] == item.id);
      item.url = target['url'];
    });
    return model;
  }

  // 获取热门歌单分类
  Future<List> getPlaylistHotCatlist() async {
    Response response = await _request('/playlist/hot');
    return response.data['tags'];
  }

  // 获取歌单
  Future getPlaylist({int limit, int offset, String cat}) async {
    await Future.delayed(Duration(seconds: 1));
    Response response = await _request('/top/playlist',
        queryParameters: {"cat": cat, "limit": limit, "offset": offset});

    return response.data;
  }

  // 获取精品歌单
  Future getPlaylistHighquality({int limit, int before, String cat}) async {
    await Future.delayed(Duration(seconds: 1));
    Response response = await _request('/top/playlist/highquality',
        queryParameters: {"cat": cat, "limit": limit, "before": before});

    return response.data;
  }

  // 获取热搜榜数据
  Future<List> getSearchHotDetail() async {
    Response response = await _request('/search/hot/detail');

    return response.data['data'];
  }

  //  默认搜索关键词
  Future getSearchDefault() async {
    Response response = await _request('/search/default');
    return response.data['data'];
  }

  // 搜索建议。
  Future getSearchSuggest(String keywords) async {
    Response response = await _request('/search/suggest', queryParameters: {"keywords": keywords, "type": "mobile"});

    return response.data['result'];
  }

  // 按照类型搜索
  Future getSearchResult(
      {String keywords, int type, int limit, int offset}) async {
    await Future.delayed(Duration(seconds: 1));
    Response response = await _request("/search", queryParameters: {
      "keywords": keywords,
      "type": type,
      "limit": limit,
      "offset": offset
    });

    return response.data["result"];
  }

  // 所有榜单内容摘要
  Future<List> getToplistDetail() async {
    await Future.delayed(Duration(seconds: 1));
    Response response = await _request('/toplist/detail');

    return response.data['list'];
  }

  ///评论类接口
  Future getComments(
      {@required int id,
      int limit,
      int offset,
      int before,
      String type}) async {
    String url;
    if (type == "music") {
      url = "/comment/music";
    } else if (type == "album") {
      url = "/comment/album";
    } else if (type == "playlist") {
      url = "/comment/playlist";
    } else if (type == "mv") {
      url = "/comment/mv";
    } else {
      url = "/comment/music";
    }
    await Future.delayed(Duration(milliseconds: 1000));
    Response response = await _request(url, queryParameters: {
      "id": id,
      "limit": limit,
      "offset": offset,
      "before": before
    });

    return response.data;
  }

  //创建的歌单
  Future getPlayList() async {
    // print('userid : '+_sp.getInt(Constant.userId).toString());
    Response response = await _request('/user/playlist',
        queryParameters: {'uid': _sp.getInt(Constant.userId)});
    return response.data;
  }

  //新建歌单  todo 报错：301
  Future addPlayList(String name, bool isPrivacy) async {
    Response response;
    switch (isPrivacy) {
      case false:
        response = await _request('/playlist/create',
            queryParameters: {'name': _sp.getInt(Constant.userId)});
        break;
      case true:
        response = await _request('/playlist/create', queryParameters: {
          'name': _sp.getInt(Constant.userId),
          'privacy': 10
        });
        break;
    }

    return response.data;
  }

  //删除歌单 todo 报错：301
  Future deletePlayList(int id) async {
    Response response =
        await _request('/playlist/delete', queryParameters: {'id': id});

    return response.data;
  }

  //获取我喜欢的音乐
  Future getMyLovedMusicsList(int uid) async {
    Response response =
        await _request('/likelist', queryParameters: {'uid': uid});

    return response.data;
  }

  // 查询个人详情
  Future getUserDetail(int uid) async {
    Response response =
        await _request('/user/detail', queryParameters: {'uid': uid});

    return response.data;
  }

  // 查询用户信息，歌单，收藏，mv，dj数量
  Future getUserSubcount(int uid) async {
    Response response =
        await _request('/user/subcount', queryParameters: {'uid': uid});

    return response.data;
  }

  // 获取用户歌单
  Future getUserPlaylist(int uid) async {
    Response response =
        await _request('/user/playlist', queryParameters: {'uid': uid});
    return response.data;
  }

  Future getUserRecord({int uid, int type}) async {
    Response response = await _request('/user/record',
        queryParameters: {'uid': uid, "type": type});

    return response.data;
  }

  //获取视频标签列表
  Future getVideoGroupList() async {
    Response response = await _request('/video/group/list');

    return response.data;
  }

  //获取视频标签下的视频  id:videoGroup的id
  Future getVideoGroup(int id) async {
    Response response =
        await _request('/video/group', queryParameters: {'id': id});

    return response.data;
  }

    //获取相关视频  id:视频的id
  Future getRelatedAllVideo(int id) async {
    Response response =
        await _request('/related/allvideo', queryParameters: {'id': id});

    return response.data;
  }

      //获取视频详情  id:视频的id
  Future getVideoDetail(int id) async {
    Response response =
        await _request('/video/detail', queryParameters: {'id': id});

    return response.data;
  }

      //获取视频播放地址  id:视频的id
  Future getVideoUrl(int id) async {
    Response response =
        await _request('/video/url', queryParameters: {'id': id});

    return response.data;
  }

}
