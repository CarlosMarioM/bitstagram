import 'package:bitstagram/models/follower.dart';
import 'package:flutter/material.dart';
import '../repository/followers_repository.dart';

class FollowersProvider with ChangeNotifier {
  final FollowersRepository _followersRepository = FollowersRepository();

  FollowersProvider();

  List<Follower> _followers = [];
  List<Follower> _following = [];
  int _followersCount = 0, _followeesCount = 0;
  bool _followedByMe = false;
  List<Follower> get followers => _followers;
  List<Follower> get following => _following;

  int get followersCount => _followersCount;
  int get followeeCount => _followeesCount;

  bool get followedByMe => _followedByMe;

  Future<bool> checkFollowedByMe(String userId) async {
    final followee = await _followersRepository.followedByMe(userId);

    if (followee == null) {
      _followedByMe = false;
    } else {
      _followedByMe = true;
    }
    notifyListeners();
    return followee != null;
  }

  Future<void> followUser(String followerId, String followeeId) async {
    await _followersRepository.followUser(followerId, followeeId);
    await fetchFollowing(followerId);
    await fetchFollowers(followerId);
    await checkFollowedByMe(followerId);
    notifyListeners();
  }

  Future<void> unfollowUser(String followerId, String followeeId) async {
    await _followersRepository.unfollowUser(followerId, followeeId);
    await fetchFollowing(followerId);
    await fetchFollowers(followerId);
    await checkFollowedByMe(followerId);
    notifyListeners();
  }

  Future<bool> fetchFollowers(String userId) async {
    _followers = await _followersRepository.getFollowers(userId);
    _followersCount = _followers.length;

    return true;
  }

  Future<bool> fetchFollowing(String userId) async {
    _following = await _followersRepository.getFollowing(userId);
    _followeesCount = _following.length;
    notifyListeners();
    return true;
  }
}
