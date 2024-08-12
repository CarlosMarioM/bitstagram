import 'package:bitstagram/models/feed/feed_response.dart';
import 'package:bitstagram/repository/pexels_repository.dart';
import 'package:flutter/material.dart';

class FeedProvider with ChangeNotifier {
  final PexelsRepository _pexelsRepository = PexelsRepository();

  FeedResponse _feed = FeedResponse.withError("initial");

  FeedResponse get feed => _feed;
  int _page = 1;
  int get page => _page;
  Future<FeedResponse> loadMoreFeed() async {
    _page += 1;
    final newFeed = await _pexelsRepository.loadFeed(page);
    _feed.feeds.addAll(newFeed.feeds);
    notifyListeners();
    return _feed;
  }

  Future<FeedResponse> loadFeed() async {
    _feed = await _pexelsRepository.loadFeed(1);
    notifyListeners();
    return _feed;
  }
}
