import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'fish_data.dart';

class TelemetryScreen extends StatefulWidget {
  @override
  _TelemetryScreenState createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  late Future<List<FishData>> futureFishData;
  Timer? _timer;
  int mostRecentFishId = 0; // Variable to keep track of the most recent fish

  @override
  void initState() {
    super.initState();
    futureFishData = fetchDummyFishData(); // Initial fetch with dummy data
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        // futureFishData = fetchFishData(mostRecentFishId); // Fetch data every 30 seconds
        futureFishData = fetchDummyFishData(); // Fetch dummy data every 30 seconds
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<List<FishData>> fetchFishData(int mostRecentFishId) async {
    final response = await http.get(Uri.parse('http://your-api-url.com/fishdata?mostRecentFishId=$mostRecentFishId'));

    if (response.statusCode == 200) {
      try {
        List jsonResponse = json.decode(response.body);
        List<FishData> fishDataList = jsonResponse.map((data) => FishData.fromJson(data)).toList();
        if (fishDataList.isNotEmpty) {
          mostRecentFishId = fishDataList.last.id; // Update the most recent fish ID
        }
        return fishDataList;
      } catch (e) {
        print('Failed to parse JSON: $e');
        print('Response body: ${response.body}');
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
      FishData(id: 1, name: 'Fish 1', imageUrl: 'https://example.com/fish1.jpg', estimatedLength: 10.5),
      FishData(id: 2, name: 'Fish 2', imageUrl: 'https://example.com/fish2.jpg', estimatedLength: 12.3),
      FishData(id: 3, name: 'Fish 3', imageUrl: 'https://example.com/fish3.jpg', estimatedLength: 8.7),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Telemetry Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pump Metrics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      // Add pump metrics UI here
                      Text('Pump Status: On'),
                      Text('Flow Rate: 10 L/min'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previous Fish Caught',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      FutureBuilder<List<FishData>>(
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
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}