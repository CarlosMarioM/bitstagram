import 'package:bitstagram/provider/feed_provider.dart';
import 'package:bitstagram/widgets/bit_circle_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/feed/feed_model.dart';
import '../../models/feed/feed_response.dart';
import '../../provider/post_provider.dart';

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
  List<FeedModel> listFeed = [];
  @override
  void initState() {
    listFeed = widget.feeds;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      listFeed = Provider.of<FeedProvider>(context).feed.feeds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: Provider.of<FeedProvider>(context).feed.feeds.length,
        itemBuilder: (context, index) {
          if (index == listFeed.length - 1) {
            Provider.of<FeedProvider>(context, listen: false).loadMoreFeed();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                VideoWidget(url: listFeed[index].videos[0].link),
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
                          BitCircleAvatar(image: listFeed[index].image),
                          const SizedBox(width: 5.0),
                          Text(
                            listFeed[index].user.name,
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
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow,
                                size: 35.0, color: Colors.white)),
                        const SizedBox(
                          height: 10.0,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share,
                                size: 30.0, color: Colors.white)),
                        const SizedBox(
                          height: 10.0,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.heart_broken_outlined,
                                size: 30.0, color: Colors.white))
                      ],
                    ))
              ],
            ),
          );
        });
  }
}

class FeedErrorWidget extends StatelessWidget {
  const FeedErrorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 140.0,
          width: 140.0,
          child: Icon(Icons.warning),
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          "Something went wrong",
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class FeedLoadingWidget extends StatelessWidget {
  const FeedLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CupertinoActivityIndicator(),
        )
      ],
    ));
  }
}

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
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
