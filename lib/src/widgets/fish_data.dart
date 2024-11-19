import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class PumpMetrics {
  final String status;
  final double flowRate;

  PumpMetrics({
    required this.status,
    required this.flowRate,
  });

  factory PumpMetrics.fromJson(Map<String, dynamic> json) {
    return PumpMetrics(
      status: json['status'],
      flowRate: json['flowRate'],
    );
  }
}



class FishData {
  final String timestamp;
  final String imageUrl; // This will still store the raw Base64 string
  final int id;

  FishData({
    required this.id,
    required this.timestamp,
    required this.imageUrl,
  });

  factory FishData.fromJson(Map<String, dynamic> json) {
    // Convert epoch time to human-readable format
    DateTime date = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);

    return FishData(
      id: json['id'],
      timestamp: formattedDate,
      imageUrl: json['imageUrl'], // Store Base64 as-is for now
    );
  }

  // Decode Base64 to bytes
  Uint8List get decodedImage => base64Decode(imageUrl);
}
