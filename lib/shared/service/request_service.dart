import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netease_flutter/models/profile.dart';
import 'package:netease_flutter/models/song.dart';

import '../../models/banner.dart';
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

  // 获取歌单详情
  Future<PlaylistModel> getPlaylistDetail(int id) async {
    Response response = await _request('/playlist/detail', queryParameters: {"id": id});
    print(response);
    return PlaylistModel.fromJson( response.data['playlist'] );
  }
  
}
