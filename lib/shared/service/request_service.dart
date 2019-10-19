import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';
import '../../models/playlist.dart';

class RequestService {

  static Dio _dio;

  static String _baseUrl;

  static BuildContext _context;

  static RequestService _instance;

  static init({String baseUrl}) {
    _baseUrl = baseUrl;
    _dio = new Dio();

    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response) {
        if (response.statusCode == 200) {
          return response;
        } else {
          showDialog(
            context: _context,
            builder: (context) => AlertDialog(
              content: Text(response.toString()),
            )
          );
          return response;
        }
      },
      onError: (DioError e) {
        return e;
      }
    ));
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

  Future<Response<T>> _request<T> (
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {

    return await _dio.post(
      _baseUrl + path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
  }

  /*
   * 手机号登录
   */
  Future<ProfileModel> login({String phone, String password}) async {
    Response response = await _request('/login/cellphone', queryParameters: {
      "phone": phone,
      "password": password
    });
    
    return ProfileModel.fromJson( response.data['profile'] );
  }

  /*
   * 轮播图数据
   */
  Future<List> getBanner() async {
    Response response = await _request('/banner', queryParameters: {
      "type": 2
    });

    return response.data['banners'];
  }

  // 获取推荐歌单
  Future<List> getRecommendPlaylist() async {
    Response response = await _request('/personalized', queryParameters: {"limit": 6});
    return response.data['result'];
  }

  // 获取歌曲详情
  Future<SongModel> getSongDetail(int id) async {
    Response response = await _request('/song/detail', queryParameters: {"ids": id});
    Response urlRes = await _request('/song/url', queryParameters: {"id": id});

    SongModel song = SongModel.fromJson( response.data['songs'][0] );
    song.url = urlRes.data['data'][0]['url'];

    return song;
  }

  // 获取歌曲播放链接
  Future<String> getSongUrl(int id) async {
    Response urlRes = await _request('/song/url', queryParameters: {"id": id});
    return urlRes.data['data'][0]['url'];
  }

  // 获取歌曲歌词
  Future<List> getSongLyric(int id) async {
    Response response = await _request('/lyric', queryParameters: {"id": id});
    if (response.data['lrc'] != null) {
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
        String time = pattern.stringMatch(line).replaceAll(new RegExp(r'\[|\]'), '');
        String word = line.replaceAll(pattern, '');
        result.add({"time": time, "lyric": word});
      });
      return result;
    }
    return [];
  }

  // 获取歌单详情
  Future<PlaylistModel> getPlaylistDetail(int id) async {
    Response response = await _request('/playlist/detail', queryParameters: {"id": id});
    return PlaylistModel.fromJson( response.data['playlist'] );
  }

  // 获取热门歌单分类
  Future<List> getPlaylistHotCatlist() async {
    Response response = await _request('/playlist/hot');
    return response.data['tags'];
  }

  Future getPlaylist({int limit, int before, String cat}) async {
    await Future.delayed(Duration(seconds: 2));
    Response response = await _request('/top/playlist', queryParameters: {
      "cat": cat,
      "limit": limit,
      "before": before
    });

    return response.data;
  }
  
  // 获取精品歌单
  Future getPlaylistHighquality({int limit, int before, String cat}) async {
    await Future.delayed(Duration(seconds: 2));
    Response response = await _request('/top/playlist/highquality', queryParameters: {
      "cat": cat,
      "limit": limit,
      "before": before
    });

    return response.data;
  }
}
