import 'dart:math';

import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../provider/post_provider.dart';
import '../views/explore/explore_page.dart';

const filledHeartURL = "assets/icons/filled_heart.png";
const emptyHeartURL = "assets/icons/empty_heart_white.png";

class BitPostComplete extends StatelessWidget {
  const BitPostComplete({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          height: 700,
          width: 600,
          child: Card(
            margin: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UserHeadlineWidget(postId: post.id),
                BitPostImage(post: post),
                _ContentWidget(post: post),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserHeadlineWidget extends StatelessWidget {
  const _UserHeadlineWidget({required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.white, width: 4),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          child: const Icon(
            Pixel.user,
            size: 30,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          supaAuth.currentUser.nickname ?? "User",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const Spacer(),
        PopupMenuButton(
            tooltip: "Options",
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Center(child: DeletePostButton(postId: postId)),
                )
              ];
            },
            child: const Icon(Pixel.menu)),
        const SizedBox(width: 16),
      ],
    );
  }
}

class DeletePostButton extends StatelessWidget {
  const DeletePostButton({
    super.key,
    required this.postId,
  });
  final String postId;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          elevation: 0,
          child: Container(
            height: 200,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.white, width: 4)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Are you sure you want to delete this post?",
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        Provider.of<PostProvider>(context, listen: false)
                            .deletePost(postId)
                            .then((_) async {
                      await Provider.of<PostProvider>(context, listen: false)
                          .loadPosts()
                          .then((value) => Navigator.of(context).pop());
                    }),
                    child: const Text("Yes"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("No"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      child: const Text(
        "Delete",
      ),
    );
  }
}

class BitPostImage extends StatelessWidget {
  const BitPostImage({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Image.network(
        post.mediaUrl,
        cacheHeight: 650,
        cacheWidth: 650,
        fit: BoxFit.fitWidth,
        filterQuality: FilterQuality.high,
        scale: 4,
        repeat: ImageRepeat.noRepeat,
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16),
          _ContentTextWidget(post: post),
          _LikeInteractionWidget(post: post),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _LikeInteractionWidget extends StatelessWidget {
  const _LikeInteractionWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          width: 35,
          child: GestureDetector(
              onTap: () => post.likedByMe
                  ? Provider.of<PostProvider>(context, listen: false)
                      .dislikePost(post.id)
                  : Provider.of<PostProvider>(context, listen: false)
                      .likePost(post.id),
              child: Icon(
                Pixel.heart,
                color: post.likedByMe ? Colors.red : Colors.white,
                fill: post.likedByMe ? 1 : 0,
              )
              // Image.network( not working on prod
              //   widget.post.likedByMe
              //       ? filledHeartURL
              //       : emptyHeartURL,
              //   cacheHeight: 30,
              //   cacheWidth: 35,
              //   scale: .5,
              // ),
              ),
        ),
        const SizedBox(height: 8),
        Text("${post.likesCount} likes")
      ],
    );
  }
}

class _ContentTextWidget extends StatelessWidget {
  const _ContentTextWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          DateFormat.MMMEd().format(post.createdAt),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 200,
          child: Text(
            post.content,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.justify,
            maxLines: 3,
            textHeightBehavior: const TextHeightBehavior(
                leadingDistribution: TextLeadingDistribution.proportional),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
