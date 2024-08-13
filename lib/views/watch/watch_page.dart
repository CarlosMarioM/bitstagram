import 'package:bitstagram/provider/feed_provider.dart';
import 'package:bitstagram/widgets/bit_circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/feed/feed_model.dart';
import '../../models/feed/feed_response.dart';
import '../../provider/post_provider.dart';
import 'feed/feed_error_widget.dart';
import 'feed/feed_loading_page.dart';

class WatchPage extends StatefulWidget {
  const WatchPage({Key? key}) : super(key: key);

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<FeedResponse>(
      future: Provider.of<FeedProvider>(context, listen: false).loadFeed(),
      builder: (context, AsyncSnapshot<FeedResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != "" && snapshot.data!.error.isNotEmpty) {
            return const FeedErrorWidget();
          }
          return FeedVideos(feeds: snapshot.data!.feeds);
        } else if (snapshot.hasError) {
          return ErrorWidget("Error");
        } else {
          return const FeedLoadingWidget();
        }
      },
    ));
  }
}

class FeedVideos extends StatefulWidget {
  const FeedVideos({
    super.key,
    required this.feeds,
  });

  final List<FeedModel> feeds;

  @override
  State<FeedVideos> createState() => _FeedVideosState();
}

class _FeedVideosState extends State<FeedVideos> {
  late final TextEditingController searchController;
  late FeedProvider feedProvider;
  @override
  void initState() {
    searchController = TextEditingController();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, FeedProvider value, child) {
      return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: value.feed.feeds.length,
        itemBuilder: (context, index) {
          if (index == value.feed.feeds.length - 1) {
            value.loadMoreFeed();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                VideoWidget(url: value.feed.feeds[index].videos[0].link),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.15)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0, 0.6, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 12.0,
                  bottom: 32.0,
                  child: SafeArea(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BitCircleAvatar(image: value.feed.feeds[index].image),
                          const SizedBox(width: 5.0),
                          Text(
                            value.feed.feeds[index].user.name,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white),
                          ),
                          const SizedBox(width: 5.0)
                        ],
                      ),
                    ],
                  )),
                ),
                Positioned(
                  right: 12.0,
                  bottom: 50.0,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            elevation: 0,
                            child: Container(
                              height: 300,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: Colors.white, width: 4)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text("Search a new topic",
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: searchController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.length < 4) {
                                          return "Invalid search";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const Spacer(),
                                    OutlinedButton(
                                      onPressed: () {
                                        value
                                            .loadFeed(
                                                topic: searchController.text)
                                            .then(
                                              (_) => mounted
                                                  ? Navigator.of(context).pop()
                                                  : null,
                                            );
                                        setState(() {});
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80.0),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
    videoPlayerController.setLooping(true);
    videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void play() {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return videoPlayerController.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoPlayerController.value.size.width,
                      height: videoPlayerController.value.size.height,
                      child: VideoPlayer(videoPlayerController),
                    ),
                  ),
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
  }
}
