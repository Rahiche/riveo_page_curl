import 'package:flutter/material.dart';
import 'package:riveo_page_curl/mobile_frame.dart';
import 'package:riveo_page_curl/projects_page.dart';

void main() => runApp(const RiveoApp());

class RiveoApp extends StatelessWidget {
  const RiveoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool shouldDisplayFrame = screenSize.width > 800;

    return MaterialApp(
      title: 'Riveo Page Curl',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: shouldDisplayFrame
          ? const MobileFrame(child: RiveoProjectsPage())
          : const RiveoProjectsPage(),
    );
  }
}
