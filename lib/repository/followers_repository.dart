import 'package:bitstagram/models/follower.dart';
import 'package:bitstagram/supabase/my_supabase.dart';
import 'package:bitstagram/supabase/supa_auth.dart';

class FollowersRepository with MySupaBase {
  FollowersRepository();

  Future<void> followUser(String followerId, String followeeId) async {
    final response = await supaAuth.client
        .from('followers')
        .insert({
          'follower_id': followerId,
          'followee_id': followeeId,
        })
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Failed to follow user');
    }
  }

  Future<void> unfollowUser(String followerId, String followeeId) async {
    final response = await client
        .from('followers')
        .delete()
        .eq('follower_id', followerId)
        .eq('followee_id', followeeId)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Failed to unfollow user');
    }
  }

  Future<Follower?> followedByMe(String userId) async {
    try {
      final followee = await client
          .from('followers')
          .select()
          .eq('follower_id', userId)
          .eq('followee_id', supaAuth.currentUser.id!)
          .maybeSingle();
      if (followee != null) {
        return Follower.fromMap(followee);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Follower>> getFollowers(String userId) async {
    try {
      final List<Map<String, dynamic>> response = await supaAuth.client
          .from('followers')
          .select()
          .eq('follower_id', userId);

      return response.map((item) => Follower.fromMap(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Follower>> getFollowing(String userId) async {
    final List<Map<String, dynamic>> response = await supaAuth.client
        .from('followers')
        .select()
        .eq('followee_id', userId);

    return response.map((item) => Follower.fromMap(item)).toList();
  }
}
