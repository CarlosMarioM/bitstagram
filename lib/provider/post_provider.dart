import 'package:bitstagram/supabase/media_service.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/like.dart';
import '../models/post.dart';
import '../repository/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final MediaService _mediaService = MediaService();
  List<Post> _posts = [];

  List<Post> get posts => _posts;

  Future<void> deletePost(String postId) async {
    await _postRepository.deletePost(postId);
  }

  Future<void> likeByMe(String postId) async {
    final Like? like = await _postRepository.likedByMe(postId);
    final index = _posts.indexWhere((element) => element.id == postId);

    if (like != null) {
      if (index != -1) {
        _posts[index].likedByMe = true;
      }
    } else {
      _posts[index].likedByMe = false;
    }

    notifyListeners();
  }

  Future<void> likePost(String postId) async {
    await _postRepository.likePost(postId);
    await addLikeCounter(postId);
    await getLikesPerPost(postId);
    await likeByMe(postId);
  }

  Future<void> dislikePost(String postId) async {
    await _postRepository.dislikePost(postId);
    await deleteLikeCounter(postId);
    await getLikesPerPost(postId);
    await likeByMe(postId);
  }

  Future<void> addLikeCounter(String postId) async {
    await _postRepository.addLikeCounter(postId);
  }

  Future<void> deleteLikeCounter(String postId) async {
    await _postRepository.deleteLikeCounter(postId);
  }

  Future<void> getLikesPerPost(String postId) async {
    final count = await _postRepository.getLikesPerPost(postId);
    final index = _posts.indexWhere((element) => element.id == postId);
    if (index != -1) {
      Post updatedPost = _posts[index];
      updatedPost.likesCount = count;
      _posts[index] = updatedPost;
    }
    notifyListeners();
  }

  Future<void> createPost(
      String storagePath, XFile file, String content) async {
    String mediaUrl = '';

    mediaUrl = await _mediaService.uploadMediaPost(storagePath, file);

    final post = Post(
      id: '',
      userId: supaAuth.currentUser.id!,
      content: content,
      mediaUrl: mediaUrl,
      mediaType: file.mimeType!,
      createdAt: DateTime.now(),
    );

    final newPost = await _postRepository.createPost(post);
    if (newPost != null) {
      _posts.insert(0, newPost);
      notifyListeners();
    }
  }

  Future<void> loadPosts() async {
    _posts = await _postRepository.fetchPosts();
    for (Post post in _posts) {
      await likeByMe(post.id);
    }
    notifyListeners();
  }

  Future<bool> fetchMyPosts() async {
    _posts = await _postRepository.fetchMyPosts();
    for (Post post in _posts) {
      await likeByMe(post.id);
    }
    notifyListeners();
    return true;
  }

  Future<bool> fetchFromPosts(String userId) async {
    _posts = await _postRepository.fetchFromPosts(userId);
    for (Post post in _posts) {
      await likeByMe(post.id);
    }
    notifyListeners();
    return true;
  }
}
