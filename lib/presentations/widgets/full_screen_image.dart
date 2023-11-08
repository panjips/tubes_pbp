import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  const FullImage({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.network(
          url,
        ),
      ),
    );
  }
}
