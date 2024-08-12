import 'package:dio/dio.dart';

import '../models/feed/feed_response.dart';

class PexelsRepository {
  static const _apiKey =
      "KHqfG7GkcEYPQOk2OupRvijeDHDLxVjgJF0mTbR8CQU0W3xAOsxtlVIp";

  static String mainUrl = "https://api.pexels.com";
  final Dio _dio = Dio();
  var getFeed = '$mainUrl/videos/search';

  Future<FeedResponse> loadFeed() async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
      "query": "food",
      "page": 1,
      "size": "small",
      "orientation ": "portrait"
    };
    try {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        options.headers["Authorization"] = _apiKey;
        //     _dio.interceptors.requestLock.unlock();

        return handler.next(options);
      }));
      Response response = await _dio.get(getFeed, queryParameters: params);
      return FeedResponse.fromJson(response.data);
    } catch (error) {
      return FeedResponse.withError("$error");
    }
  }
}
