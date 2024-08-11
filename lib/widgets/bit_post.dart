import 'dart:math';

import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../provider/post_provider.dart';
import '../views/explore/explore_page.dart';

const filledHeartURL = "assets/icons/filled_heart.png";
const emptyHeartURL = "assets/icons/empty_heart_white.png";

class BitPostComplete extends StatefulWidget {
  const BitPostComplete({super.key, required this.post});
  final Post post;
  @override
  State<BitPostComplete> createState() => _BitPostCompleteState();
}

class _BitPostCompleteState extends State<BitPostComplete> {
  @override
  void initState() {
    super.initState();
  }

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
                Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      child: const Icon(
                        Icons.person_outline_outlined,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      supaAuth.currentUser.nickname ?? "User",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const Spacer(),
                    const IconButton(onPressed: null, icon: Icon(Icons.menu))
                  ],
                ),
                Expanded(
                  flex: 4,
                  child: Image.network(
                    widget.post.mediaUrl,
                    cacheHeight: 650,
                    cacheWidth: 650,
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high,
                    scale: 4,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            DateFormat.MMMEd().format(widget.post.createdAt),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 280,
                            child: Text(
                              widget.post.content,
                              style: Theme.of(context).textTheme.labelMedium,
                              textAlign: TextAlign.justify,
                              maxLines: 3,
                              textHeightBehavior: const TextHeightBehavior(
                                  leadingDistribution:
                                      TextLeadingDistribution.proportional),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 35,
                            child: GestureDetector(
                              onTap: () => widget.post.likedByMe
                                  ? Provider.of<PostProvider>(context,
                                          listen: false)
                                      .dislikePost(widget.post.id)
                                  : Provider.of<PostProvider>(context,
                                          listen: false)
                                      .likePost(widget.post.id),
                              child: Image.network(
                                widget.post.likedByMe
                                    ? filledHeartURL
                                    : emptyHeartURL,
                                cacheHeight: 30,
                                cacheWidth: 35,
                                scale: .5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("${widget.post.likesCount} likes")
                        ],
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
