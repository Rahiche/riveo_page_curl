import 'package:device_frame/device_frame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Center(
            child: DeviceFrame(
              device: Devices.ios.iPhone12ProMax,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: child,
            ),
          ),
          Link(
              uri: Uri.parse('https://github.com/Rahiche/riveo_page_curl'),
              builder: (context, followLink) {
                return RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Github Repository',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = followLink,
                    ),
                  ]),
                );
              }),
        ],
      ),
    );
  }
}
