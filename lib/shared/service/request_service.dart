import 'package:dio/dio.dart';

class RequestService {

  Dio _dio = new Dio();

  static String _baseUrl;

  static RequestService _instance;

  static init({String baseUrl}) {
    _baseUrl = baseUrl;
  }

  static RequestService getInstance() {
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

  Future _request(uri, Map<String, dynamic> query) {
    uri = _baseUrl + uri;
    return _dio.post(uri, queryParameters: query);
  }

  /*
   * 手机号登录
   */
  Future login({String phone, String password}) {
    return _request('/login/cellphone', {
      "phone": phone,
      "password": password
    });
  }

  /*
   * 轮播图数据
   */
  Future getBanner() {
    return _request('/banner', {
      "type": 2
    });
  }

  // 获取推荐歌单
  Future getRecommendPlaylist() => _request('/personalized', {"limit": 6});

  // 获取歌曲详情
  Future getSongDetail(String id) => _request('/song/detail', {"ids": id});

  // 获取歌单详情
  Future getPlaylistDetail(int id) => _request('/playlist/detail', {"id": id});
  
}
