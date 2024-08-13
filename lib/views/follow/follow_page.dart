import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/followers_provider.dart';

enum FollowEnum { follower, following }

class FollowersScreen extends StatelessWidget {
  final String userId;
  final FollowEnum followEnum;
  const FollowersScreen({required this.userId, required this.followEnum});

  @override
  Widget build(BuildContext context) {
    final followersProvider = Provider.of<FollowersProvider>(context);

    return Scaffold(
      body: FutureBuilder(
        future: switch (followEnum) {
          FollowEnum.follower => Future.sync(() async {
              await followersProvider.fetchFollowers(userId);
            }),
          FollowEnum.following => followersProvider.fetchFollowing(userId),
        },
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FeedLoadingWidget();
          } else if (snapshot.hasError) {
            return const FeedErrorWidget();
          } else {
            return ListView.builder(
              itemCount: switch (followEnum) {
                FollowEnum.follower => followersProvider.followers.length,
                FollowEnum.following => followersProvider.following.length,
              },
              itemBuilder: (context, index) {
                final follow = switch (followEnum) {
                  FollowEnum.follower => followersProvider.followers[index],
                  FollowEnum.following => followersProvider.following[index],
                };
                return ListTile(
                  title: Text(follow.followerId),
                );
              },
            );
          }
        },
      ),
    );
  }
}
