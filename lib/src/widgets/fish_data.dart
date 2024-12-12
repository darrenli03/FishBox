import 'dart:typed_data';
import 'dart:convert';


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
  final int id;
  final Uint8List imageBytes; // Decoded image data

  FishData({
    required this.id,
    required this.imageBytes,
  });

  factory FishData.fromJson(Map<String, dynamic> json) {
    return FishData(
      id: json['id'],
      imageBytes: base64Decode(json['image_data']), // Decode Base64 string
    );
  }
}
