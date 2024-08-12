import 'package:bitstagram/models/explore/photos_response_model.dart';
import 'package:bitstagram/provider/feed_provider.dart';
import 'package:bitstagram/views/watch/watch_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../provider/explore_provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  PhotosResponse? photosResponse;
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController(keepScrollOffset: true);
    controller.addListener(() {
      if (controller.offset == 1) {
        Provider.of<ExploreProvider>(context, listen: false).loadMoreExplore();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      photosResponse = Provider.of<ExploreProvider>(context).explore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ExploreProvider>(context).loadExplore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            photosResponse ??= snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: SizedBox(
                width: 500,
                height: 200,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 600,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            label: Text("Search"),
                            suffixIcon: Icon(Icons.search)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: MasonryGridView.builder(
                            controller: controller,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: photosResponse?.perPage ?? 0,
                            addAutomaticKeepAlives: true,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            itemBuilder: (context, index) {
                              return Image.network(
                                photosResponse?.photos[index].src.original ??
                                    "",
                                scale: 2,
                                fit: BoxFit.fitWidth,
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const FeedLoadingWidget();
          }
        });
  }
}
