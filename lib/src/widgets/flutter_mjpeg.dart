// lib/src/widgets/mjpeg_stream_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../settings/settings_view.dart'; // Import the settings view
import '../settings/settings_controller.dart';

class MjpegStreamPage extends StatelessWidget {
  const MjpegStreamPage({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  final String streamUrl = 'http://localhost:8000/stream.mjpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MJPEG Stream'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsView(controller: settingsController),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Mjpeg(
          stream: streamUrl,
          isLive: true,
          error: (context, error, stackTrace) {
            return Text('Error loading stream');
          },
        ),
      ),
    );
  }
}
