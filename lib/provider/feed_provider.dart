import 'package:bitstagram/models/feed/feed_response.dart';
import 'package:bitstagram/repository/pexels_repository.dart';
import 'package:flutter/material.dart';

class FeedProvider with ChangeNotifier {
  final PexelsRepository _pexelsRepository = PexelsRepository();

  FeedResponse _feed = FeedResponse.withError("initial");

  FeedResponse get feed => _feed;

  Future<FeedResponse> loadFeed() async {
    _feed = await _pexelsRepository.loadFeed();
    notifyListeners();
    return _feed;
  }
}
