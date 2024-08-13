import 'package:bitstagram/provider/followers_provider.dart';
import 'package:bitstagram/provider/post_provider.dart';
import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:bitstagram/views/account/update_account_page.dart';
import 'package:bitstagram/views/follow/follow_page.dart';
import 'package:bitstagram/views/splash/loading_splash_page.dart';
import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:bitstagram/widgets/appbart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:provider/provider.dart';

import '../../models/follower.dart';
import '../../models/user.dart';
import '../../widgets/bit_circle_avatar.dart';
import '../explore/explore_page.dart';

class ProfileAccountPage extends StatefulWidget {
  const ProfileAccountPage({super.key, required this.user});
  final User user;

  @override
  State<ProfileAccountPage> createState() => _ProfileAccountPageState();
}

class _ProfileAccountPageState extends State<ProfileAccountPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppbar,
      body: AccountPage(user: widget.user),
    );
  }
}

class AccountPage extends StatefulWidget {
  AccountPage({super.key, this.user});

  User? user;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late final TabController controller;
  late final PostProvider postProvider;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);

    controller = TabController(length: 1, vsync: this);
    widget.user ??= supaAuth.currentUser;
    widget.user?.id == supaAuth.currentUser.id
        ? postProvider.fetchMyPosts()
        : postProvider.fetchFromPosts(widget.user!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, PostProvider value, child) {
        return Column(
          children: [
            UserHeaderWidget(user: widget.user!),
            TabBar(
              controller: controller,
              tabs: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.photo_camera_front_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: value.posts.length,
                addAutomaticKeepAlives: true,
                semanticChildCount: value.posts.length,
                itemBuilder: (context, index) =>
                    Image.network(postProvider.posts[index].mediaUrl),
              ),
            )
          ],
        );
      },
    );
  }
}

class UserHeaderWidget extends StatefulWidget {
  const UserHeaderWidget({super.key, required this.user});
  final User user;

  @override
  State<UserHeaderWidget> createState() => _UserHeaderWidgetState();
}

class _UserHeaderWidgetState extends State<UserHeaderWidget> {
  late FollowersProvider followProvider;
  late UserProvider userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    followProvider = Provider.of<FollowersProvider>(context, listen: false);
    followProvider.checkFollowedByMe(widget.user.id!);
    followProvider.fetchFollowers(widget.user.id!);
    followProvider.fetchFollowing(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (context, FollowersProvider value, UserProvider user, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BitCircleAvatar(
                        height: 70, width: 70, image: widget.user.photoUrl),
                    const SizedBox(height: 26),
                    Text(widget.user.nickname ?? "User",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                const Spacer(),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Following ${value.followeeCount}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Followers ${value.followersCount}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton(
                      onPressed: () {
                        if (widget.user.id == supaAuth.currentUser.id) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateAccountPage(),
                              ));
                        } else {
                          if (value.followedByMe) {
                            value.unfollowUser(
                              widget.user.id!,
                              supaAuth.currentUser.id!,
                            );
                          } else {
                            value.followUser(
                                widget.user.id!, supaAuth.currentUser.id!);
                          }
                        }
                      },
                      child: widget.user.id == supaAuth.currentUser.id
                          ? const Text("Change")
                          : value.followedByMe
                              ? const Text("Following")
                              : const Text("Follow")),
                ),
                if (supaAuth.currentUser.id == widget.user.id) ...{
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: OutlinedButton(
                        onPressed: () {
                          user.signOut();
                        },
                        child: const Text("Logout")),
                  ),
                }
              ],
            ),
          ),
        );
      },
    );
  }
}
