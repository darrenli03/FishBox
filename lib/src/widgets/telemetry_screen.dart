import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'fish_data.dart';

class TelemetryScreen extends StatefulWidget {
  @override
  _TelemetryScreenState createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  late Future<List<FishData>> futureFishData;

  @override
  void initState() {
    super.initState();
    futureFishData = fetchDummyFishData(); // Use the mock method for testing
  }

  Future<List<FishData>> fetchFishData() async {
    final response = await http.get(Uri.parse('http://your-api-url.com/fishdata'));

    if (response.statusCode == 200) {
      try {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => FishData.fromJson(data)).toList();
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      print('Server responded with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load fish data');
    }
  }

  Future<List<FishData>> fetchDummyFishData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return [
      FishData(name: 'Fish 1', imageUrl: 'https://example.com/fish1.jpg', estimatedLength: 10.5),
      FishData(name: 'Fish 2', imageUrl: 'https://example.com/fish2.jpg', estimatedLength: 12.3),
      FishData(name: 'Fish 3', imageUrl: 'https://example.com/fish3.jpg', estimatedLength: 8.7),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telemetry Screen'),
      ),
      body: FutureBuilder<List<FishData>>(
        future: futureFishData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FishData fish = snapshot.data![index];
                return ListTile(
                  leading: Hero(
                    tag: 'fishImage_${fish.name}', // Ensure unique tag
                    child: Image.network(fish.imageUrl),
                  ),
                  title: Text(fish.name),
                  subtitle: Text('Estimated Length: ${fish.estimatedLength} cm'),
                );
              },
            );
          }
        },
      ),
    );
  }
}