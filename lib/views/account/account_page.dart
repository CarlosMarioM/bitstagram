import 'package:bitstagram/provider/post_provider.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:bitstagram/views/splash/loading_splash_page.dart';
import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../widgets/bit_circle_avatar.dart';
import '../explore/explore_page.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key, this.isMe = true, this.user});
  final bool isMe;
  User? user;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    controller = TabController(length: 1, vsync: this);
    widget.user ??= supaAuth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    return FutureBuilder(
        future: widget.isMe
            ? postProvider.fetchMyPosts()
            : postProvider.fetchFromPosts(widget.user!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                    itemCount: postProvider.posts.length,
                    addAutomaticKeepAlives: true,
                    semanticChildCount: postProvider.posts.length,
                    itemBuilder: (context, index) =>
                        Image.network(postProvider.posts[index].mediaUrl),
                  ),
                )
              ],
            );
          } else {
            return const FeedLoadingWidget();
          }
        });
  }
}

class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    super.key,
    required this.user,
  });
  final User user;
  @override
  Widget build(BuildContext context) {
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
                BitCircleAvatar(height: 70, width: 70, image: user.photoUrl),
                const SizedBox(height: 26),
                Text(
                  user.nickname ?? "User",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  "Following 0 ",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Followers 0 ",
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
