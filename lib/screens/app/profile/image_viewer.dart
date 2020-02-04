import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:seeds/models/models.dart';

class ImageViewer extends StatelessWidget {
  final ProfileModel profileModel;
  const ImageViewer({this.profileModel});

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
            heroAttributes: const PhotoViewHeroAttributes(tag: "profilePic"),
            imageProvider: CachedNetworkImageProvider(
              profileModel.image,
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
