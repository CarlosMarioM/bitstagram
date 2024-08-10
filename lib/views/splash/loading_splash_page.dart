import 'package:bitstagram/widgets/appbart.dart';
import 'package:flutter/material.dart';

class LoadingSplashPage extends StatelessWidget {
  const LoadingSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: normalAppbar,
        body: const Center(child: CircularProgressIndicator()));
  }
}
