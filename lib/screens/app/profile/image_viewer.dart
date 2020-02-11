import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerArguments {
  final String imageUrl;
  final String heroTag;

  const ImageViewerArguments({this.imageUrl, this.heroTag});
}

class ImageViewer extends StatelessWidget {
  final ImageViewerArguments arguments;

  const ImageViewer({this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PhotoView(
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: arguments.heroTag),
            imageProvider: CachedNetworkImageProvider(
              arguments?.imageUrl ?? '',
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: const Color(0x00000000),
              elevation: 0.0,
            ),
          )
        ],
      ),
    );
  }
}
