import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:photo_view/photo_view.dart';

class ImgFullScreenPage extends StatelessWidget {
  final Uint8List ImgDecode;
  ImgFullScreenPage({required this.ImgDecode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 35,
              color:
                  Color.fromRGBO(250, 246, 229, 1), // Light-colored back icon
            ),
          ),
        ),
        body: PhotoView(
          imageProvider: MemoryImage(ImgDecode),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          enableRotation: true,
        ),
      ),
    );
  }
}

//  body: PhotoView(
//         imageProvider: MemoryImage(ImgDecode),
//         backgroundDecoration: BoxDecoration(color: Colors.black),
//         minScale: PhotoViewComputedScale.contained,
//         maxScale: PhotoViewComputedScale.covered * 3.0,
//         enableRotation: true, // Optional for rotating the image
//       ),