import 'package:bitstagram/models/explore/photos_response_model.dart';
import 'package:flutter/material.dart';

import '../repository/pexels_repository.dart';

class ExploreProvider with ChangeNotifier {
  final PexelsRepository _pexelsRepository = PexelsRepository();

  PhotosResponse _explore = PhotosResponse(
      totalResults: 0, page: 0, perPage: 0, photos: [], nextPage: "");

  PhotosResponse get explore => _explore;
  int _page = 1;
  int get page => _page;
  Future<PhotosResponse> loadMoreExplore() async {
    _page += 1;
    final newExplore = await _pexelsRepository.loadExplore(page);
    _explore.photos.addAll(newExplore.photos);
    notifyListeners();
    return _explore;
  }

  Future<PhotosResponse> loadExplore() async {
    _explore = await _pexelsRepository.loadExplore(1);
    notifyListeners();
    return _explore;
  }
}
