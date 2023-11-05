import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DeviceFrame(
        device: Devices.ios.iPhone12ProMax,
        isFrameVisible: true,
        orientation: Orientation.portrait,
        screen: child,
      ),
    );
  }
}
