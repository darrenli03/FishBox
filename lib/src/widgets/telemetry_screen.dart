import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'fish_data.dart';

class TelemetryScreen extends StatefulWidget {
  const TelemetryScreen({super.key});

  @override
  _TelemetryScreenState createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  List<FishData> fishDataList = [];
  PumpMetrics pumpMetrics = PumpMetrics(status: 'Unknown', flowRate: 0.0);
  Timer? _timer;
  int mostRecentFishId = 1; // Variable to keep track of the most recent fish

  @override
  void initState() {
    bool dummyCheck = false;
    super.initState();
    fetchDummyPumpMetrics(); // Fetch dummy pump metrics
    // fetchDummyFishData(); // Fetch dummy fish data
    fetchFishData(mostRecentFishId); // Fetch fish data
    setState(() {
      fishDataList.add(
        FishData(
          id: 1,
          timestamp: '2024-06-59T22:16:18Z',
          imageUrl: 'assets/images/fish.jpg', // Local image path
          estimatedLength: 9.5,
        ),
      );
    });

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchDummyPumpMetrics(); // Fetch dummy pump metrics every 30 seconds
      fetchDummyFishData(dummyCheck); // Fetch dummy fish data every 30 seconds
      dummyCheck = true;
      // fetchFishData(mostRecentFishId); // Fetch fish data every 30 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchDummyPumpMetrics() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      pumpMetrics = PumpMetrics(status: 'Running', flowRate: 15.0);
    });
  }

  Future<void> fetchDummyFishData(bool dummyCheck) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    List<FishData> newFishDataList = [];
    if (dummyCheck == false) {
    newFishDataList.add(FishData(id: 2, timestamp: '2015-07-05T22:16:18Z', imageUrl: 'https://example.com/fish2.jpg', estimatedLength: 12.3));
    newFishDataList.add(FishData(id: 3, timestamp: '2015-07-05T22:16:18Z', imageUrl: 'https://example.com/fish3.jpg', estimatedLength: 8.7));
    }
    setState(() {
    if (newFishDataList.isNotEmpty) {
      fishDataList.addAll(newFishDataList);
      mostRecentFishId = newFishDataList.last.id; // Update the most recent fish ID
    }
    });
  }

  Future<void> fetchFishData(int mostRecentFishId) async {
    try {
      final response = await http.get(Uri.parse('http://10.42.0.1:8000/'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<FishData> newFishDataList = jsonResponse.map((data) => FishData.fromJson(data)).toList();

        // Download and save images locally
        for (FishData fish in newFishDataList) {
          fishDataList.add(fish);
        } 
        setState(() {
          fishDataList.addAll(newFishDataList);
          if (newFishDataList.isNotEmpty) {
            mostRecentFishId = newFishDataList.last.id; // Update the most recent fish ID
          }
        });
      } else {
        print('Failed to load fish data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load fish data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemetry'),
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
                      Text('Pump Status: ${pumpMetrics.status}'),
                      Text('Flow Rate: ${pumpMetrics.flowRate} L/min'),
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: fishDataList.length,
                        itemBuilder: (context, index) {
                          FishData fish = fishDataList[index];
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: 'fishImage_${fish.timestamp}', // Ensure unique tag
                                    child: fish.imageUrl.startsWith('assets/')
                                        ? Image.asset(fish.imageUrl, fit: BoxFit.cover)
                                        : Image.network(fish.imageUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: 8.0), // Add some spacing between the image and text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Fish #${fish.id}",
                                        style: const TextStyle(
                                        
                                        fontWeight: FontWeight.bold, 
                                      ),
                                    ),
                                    const Text('Length Estimate:'),
                                    Text('${fish.estimatedLength} cm', 
                                      style: const TextStyle(
                                        fontSize: 12.0, // Slightly smaller font size
                                        fontWeight: FontWeight.normal, // Not bolded
                                      ),
                                    ),
                                    const Text("Caught on:"),
                                    Text(fish.timestamp, 
                                        style: const TextStyle(
                                        fontSize: 12.0, // Slightly smaller font size
                                        fontWeight: FontWeight.normal, // Not bolded
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
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