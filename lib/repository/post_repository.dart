import 'package:bitstagram/models/like.dart';
import 'package:bitstagram/supabase/my_supabase.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post.dart';

class PostRepository with MySupaBase {
  late final Stream<Post> _postStream;

  Stream<Post> get postStream => _postStream;

  Future<Post?> createPost(Post post) async {
    try {
      final response = await client
          .from('posts')
          .insert({
            "content": post.content,
            "media_url": post.mediaUrl,
            "media_type": post.mediaType,
            "user_id": post.userId,
          })
          .select()
          .single();

      if (response.isEmpty) {
        throw Exception('Failed to create post:');
      }

      return Post.fromMap(response);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Post>> fetchPosts() async {
    final response = await client
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return response.map<Post>((data) => Post.fromMap(data)).toList();
  }

  Future<List<Post>> fetchMyPosts() async {
    final response = await client
        .from('posts')
        .select()
        .eq('user_id', supaAuth.currentUser.id!)
        .order('created_at', ascending: false);

    return response.map<Post>((data) => Post.fromMap(data)).toList();
  }

  Future<List<Post>> fetchFromPosts(String userId) async {
    final response = await client
        .from('posts')
        .select()
        .eq('id', userId)
        .order('created_at', ascending: false);

    return response.map<Post>((data) => Post.fromMap(data)).toList();
  }

  Future<void> deletePost(String postId) async {
    try {
      final response = await client
          .from('posts')
          .select()
          .eq('id', postId)
          .then((value) => Post.fromMap(value.first));

      await client.storage.from("posts").remove([
        "${supaAuth.currentUser.id!}/${response.createdAt.microsecondsSinceEpoch}"
      ]);

      await client.from("posts").delete().eq("id", postId);
    } catch (e) {
      print(e);
    }
  }

  Future<Like?> likedByMe(String postId) async {
    try {
      final likeMap = await client
          .from('likes')
          .select()
          .eq('user_id', supaAuth.currentUser.id!)
          .eq('post_id', postId)
          .maybeSingle();
      if (likeMap != null) {
        return Like.fromMap(likeMap!);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> dislikePost(String postId) async {
    await client
        .from('likes')
        .delete()
        .eq("user_id", supaAuth.currentUser.id!)
        .eq("post_id", postId);
  }

  Future<void> likePost(String postId) async {
    try {
      await client.from('likes').insert({
        'user_id': supaAuth.currentUser.id!,
        'post_id': postId,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteLikeCounter(String postId) async {
    try {
      final postMap =
          await client.from('posts').select().eq('id', postId).single();
      final post = Post.fromMap(postMap);
      int likesDecreased = post.likesCount - 1;
      if (likesDecreased < 0) {
        likesDecreased = 0;
      }
      await client
          .from('posts')
          .update({'likes_count': likesDecreased}).eq('id', postId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addLikeCounter(String postId) async {
    try {
      final postMap =
          await client.from('posts').select().eq('id', postId).single();
      final post = Post.fromMap(postMap);
      final likesIncreased = post.likesCount + 1;
      await client
          .from('posts')
          .update({'likes_count': likesIncreased}).eq('id', postId);
    } catch (e) {
      print(e);
    }
  }

  Future<int> getLikesPerPost(String postId) async {
    try {
      final response = await client
          .from("posts")
          .select('likes_count')
          .eq('id', postId)
          .single();
      return response["likes_count"];
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
