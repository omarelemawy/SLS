import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import '../widget/camera_button_widget.dart';
import '../widget/gallery_button_widget.dart';

class SourcePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      body: ListView(
        children: [
          CameraButtonWidget(),
          GalleryButtonWidget(),
        ],
      ),
    );
  }
}
