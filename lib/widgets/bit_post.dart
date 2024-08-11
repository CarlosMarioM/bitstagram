import 'dart:math';

import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/supabase/supa_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../provider/post_provider.dart';
import '../views/explore/explore_page.dart';

const filledHeartURL = "assets/icons/filled_heart.png";
const emptuyHeartURL = "assets/icons/empty_heart.png";

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
          height: 500,
          width: 600,
          child: Card(
            margin: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.person_outline_outlined),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "MarioMederos",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const Spacer(),
                    const IconButton(onPressed: null, icon: Icon(Icons.menu))
                  ],
                ),
                Expanded(
                  flex: 3,
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
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 380,
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
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          width: 35,
                          child: GestureDetector(
                              onTap: () => widget.post.likedByMe
                                  ? Provider.of<PostProvider>(context,
                                          listen: false)
                                      .dislike(widget.post.id)
                                  : Provider.of<PostProvider>(context,
                                          listen: false)
                                      .likePost(
                                      supaAuth.currentUser.id!,
                                      widget.post.id,
                                    ),
                              child: Image.network(
                                widget.post.likedByMe
                                    ? filledHeartURL
                                    : emptuyHeartURL,
                                cacheHeight: 30,
                                cacheWidth: 35,
                                scale: .5,
                              )),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
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
