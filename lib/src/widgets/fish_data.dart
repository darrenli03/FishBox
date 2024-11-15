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
  final String imageUrl;
  final double estimatedLength;
  final int id;

  FishData({
    required this.id,
    required this.timestamp,
    required this.imageUrl,
    required this.estimatedLength,
  });

  factory FishData.fromJson(Map<String, dynamic> json) {
    return FishData(
      id: json['id'],
      timestamp: json['timestamp'],
      imageUrl: json['imageUrl'],
      estimatedLength: json['estimatedLength'],
    );
  }
}