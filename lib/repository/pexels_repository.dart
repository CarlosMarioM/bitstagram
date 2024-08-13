import 'package:bitstagram/models/explore/photos_response_model.dart';
import 'package:dio/dio.dart';

import '../models/feed/feed_response.dart';

class PexelsRepository {
  static const _apiKey =
      "KHqfG7GkcEYPQOk2OupRvijeDHDLxVjgJF0mTbR8CQU0W3xAOsxtlVIp";

  static String mainUrl = "https://api.pexels.com";
  final Dio _dio = Dio();
  var getExplore = '$mainUrl/v1/search';
  var getFeed = '$mainUrl/videos/search';

  Future<PhotosResponse> loadExplore(int page) async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
      "query": "art",
      "page": page,
      "size": "small",
      "orientation ": "portrait",
      "perPage": 15,
    };
    try {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        options.headers["Authorization"] = _apiKey;

        return handler.next(options);
      }));
      Response response = await _dio.get(getExplore, queryParameters: params);
      return PhotosResponse.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<FeedResponse> loadFeed(int page, {String topic = "food"}) async {
    var params = {
      "api_key": _apiKey,
      "language": "en-US",
      "query": topic,
      "page": page,
      "size": "small",
      "orientation ": "portrait"
    };
    try {
      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        options.headers["Authorization"] = _apiKey;

        return handler.next(options);
      }));
      Response response = await _dio.get(getFeed, queryParameters: params);
      return FeedResponse.fromJson(response.data);
    } catch (error) {
      return FeedResponse.withError("$error");
    }
  }
}
