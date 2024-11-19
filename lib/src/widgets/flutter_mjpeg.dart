// lib/src/widgets/mjpeg_stream_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../settings/settings_view.dart'; // Import the settings view
import '../settings/settings_controller.dart';
import 'telemetry_screen.dart'; 

class MjpegStreamPage extends StatelessWidget {
  const MjpegStreamPage({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  // final String streamUrl = 'http://10.42.0.1:8000/stream.mjpg';
  final String streamUrl = 'http://10.194.27.154:8000/stream.mjpg';
  // final String streamUrl = 'http://10.146.90.63:8000/stream.mjpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FishBox Controls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelemetryScreen(), // Navigate to TelemetryScreen
                ),
              );
            },
          ),
          
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
