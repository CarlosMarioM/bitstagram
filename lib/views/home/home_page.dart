import 'package:bitstagram/provider/post_provider.dart';
import 'package:bitstagram/widgets/bit_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PostProvider postProvider;
  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    postProvider.loadPosts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, PostProvider value, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                semanticChildCount: value.posts.length,
                controller: ScrollController(),
                itemCount: value.posts.length,
                itemBuilder: (context, index) => BitPostComplete(
                  post: value.posts[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
