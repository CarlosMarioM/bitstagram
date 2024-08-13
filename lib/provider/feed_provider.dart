import 'package:bitstagram/models/explore/photos_response_model.dart';
import 'package:bitstagram/models/feed/feed_response.dart';
import 'package:bitstagram/repository/pexels_repository.dart';
import 'package:flutter/material.dart';

class FeedProvider with ChangeNotifier {
  final PexelsRepository _pexelsRepository = PexelsRepository();

  FeedResponse _feed = FeedResponse.withError("initial");

  FeedResponse get feed => _feed;
  int _page = 1;
  int get page => _page;
  Future<FeedResponse> loadMoreFeed({String topic = "food"}) async {
    _page += 1;
    final newFeed = await _pexelsRepository.loadFeed(page, topic: topic);
    _feed.feeds.addAll(newFeed.feeds);
    notifyListeners();
    return _feed;
  }

  Future<FeedResponse> loadFeed({String topic = "food"}) async {
    _feed = await _pexelsRepository.loadFeed(1, topic: topic);
    notifyListeners();
    return _feed;
  }
}
