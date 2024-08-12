import 'package:bitstagram/models/explore/photo_model.dart';

class PhotosResponse {
  final int totalResults;
  final int page;
  final int perPage;
  final List<Photo> photos;
  final String nextPage;

  PhotosResponse({
    required this.totalResults,
    required this.page,
    required this.perPage,
    required this.photos,
    required this.nextPage,
  });

  factory PhotosResponse.fromJson(Map<String, dynamic> json) {
    return PhotosResponse(
      totalResults: json['total_results'],
      page: json['page'],
      perPage: json['per_page'],
      photos: (json['photos'] as List).map((i) => Photo.fromJson(i)).toList(),
      nextPage: json['next_page'],
    );
  }
}
