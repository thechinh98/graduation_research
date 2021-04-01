// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

class ImageZoomWidget extends StatefulWidget {
  final String imageUrl;
  final String questionId;

  ImageZoomWidget({Key? key, required this.imageUrl, required this.questionId}) : super(key: key);

  @override
  _ImageZoomWidgetState createState() => _ImageZoomWidgetState();
}

class _ImageZoomWidgetState extends State<ImageZoomWidget> {
  Widget getImageWidget(imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      alignment: Alignment.center,
      child: Container(
        color: Colors.redAccent.withOpacity(0.0),
        margin: EdgeInsets.all(8),
        //color: Colors.white,
        child: Hero(
          tag: "imageZoom_" +
              widget.questionId +
              "-" +
              new Random().nextInt(999999).toString(),
          child: getImageWidget(widget.imageUrl),
        ),
      ),
    );
  }
}
