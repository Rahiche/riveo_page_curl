import 'dart:ui' as ui;

import 'package:riveo_page_curl/projects/card/project_card_constants.dart';

class ShaderHelper {
  static void configureShader(
    ui.FragmentShader shader,
    ui.Size size,
    ui.Image image,
    double pointer,
  ) {
    shader
      ..setFloat(0, size.width) // resolution
      ..setFloat(1, size.height) // resolution
      ..setFloat(2, pointer) // pointer
      ..setFloat(3, 0) // origin
      ..setFloat(4, 0) // inner container
      ..setFloat(5, 0) // inner container
      ..setFloat(6, size.width) // inner container
      ..setFloat(7, size.height) // inner container
      ..setFloat(8, ProjectCardConstants.cornerRadius) // cornerRadius
      ..setImageSampler(0, image); // image
  }

  static void drawShaderRect(
      ui.FragmentShader shader, ui.Size size, ui.Canvas canvas) {
    canvas.drawRect(
      ui.Rect.fromCenter(
        center: ui.Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      ui.Paint()..shader = shader,
    );
  }
}
