import 'package:bitstagram/widgets/bit_post.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => const BitPostComplete(),
          ),
        ),
      ),
    );
  }
}
