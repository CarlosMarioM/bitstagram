import 'package:flutter/material.dart';

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
