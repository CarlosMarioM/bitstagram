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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<PostProvider>(context, listen: false).loadPosts(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ListView.builder(
                  itemCount: Provider.of<PostProvider>(context).posts.length,
                  itemBuilder: (context, index) => BitPostComplete(
                    post: Provider.of<PostProvider>(context).posts[index],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
