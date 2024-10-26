// lib/src/sample_feature/sample_item_list_view.dart
import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';
import 'video_screen.dart'; // Import the new video screen

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [TelemetryItem(1)],
  });

  static const routeName = '/';

  final List<TelemetryItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.video_library),
            onPressed: () {
              Navigator.restorablePushNamed(context, VideoScreen.routeName);
            },
          ),
        ],
      ),
      // Rest of the code...
    );
  }
}