import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;
  final BoxFit boxFit;

  CachedImage(this.imageUrl,
      {this.isRound = false,
      this.radius,
      this.height,
      this.width,
      this.boxFit});

  final String noImageAvailable =
      "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg";

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? 50 : radius),
          child: CachedNetworkImage(
            fit: boxFit,
            imageUrl: imageUrl,
            placeholder: (context, url) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorWidget: (context, url, error) {
              return Image.network(
                noImageAvailable,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
      return Image.network(
        noImageAvailable,
        fit: BoxFit.cover,
      );
    }
  }
}
