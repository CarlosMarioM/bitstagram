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

  bool _like = false;
  bool get like => _like;

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
    try {
      await _postRepository.likePost(postId);
      await addLikeCounter(postId);
      await getLikesPerPost(postId);
      await likeByMe(postId);
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> dislikePost(String postId) async {
    await _postRepository.dislikePost(postId);
    await deleteLikeCounter(postId);
    await getLikesPerPost(postId);
    await likeByMe(postId);
  }

  Future<void> addLikeCounter(String postId) async {
    try {
      await _postRepository.addLikeCounter(postId);
    } catch (e) {}
  }

  Future<void> deleteLikeCounter(String postId) async {
    try {
      await _postRepository.deleteLikeCounter(postId);
    } catch (e) {}
  }

  Future<void> getLikesPerPost(String postId) async {
    try {
      final count = await _postRepository.getLikesPerPost(postId);
      final index = _posts.indexWhere((element) => element.id == postId);
      if (index != -1) {
        Post updatedPost = _posts[index];
        updatedPost.likesCount = count;
        _posts[index] = updatedPost;
      }
      notifyListeners();
    } catch (e) {}
  }

  Future<void> createPost(
      String storagePath, XFile file, String content) async {
    String mediaUrl = '';

    mediaUrl = await _mediaService.uploadMedia(storagePath, file);

    final post = Post(
      id: '', // Supabase will generate the ID automatically
      userId: supaAuth.currentUser.id!,
      content: content,
      mediaUrl: mediaUrl, // Add the media URL
      mediaType: file.mimeType!, // Add the media type
      createdAt: DateTime.now(),
    );

    try {
      final newPost = await _postRepository.createPost(post);
      if (newPost != null) {
        _posts.insert(0, newPost); // Add to the beginning of the list
        notifyListeners();
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future<void> loadPosts() async {
    try {
      _posts = await _postRepository.fetchPosts();
      for (Post post in _posts) {
        await likeByMe(post.id);
      }
      notifyListeners();
    } catch (e) {
      print('Error loading posts: $e');
    }
  }
}
