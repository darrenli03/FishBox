import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const double widthConstraint = 450;
const smallSpacing = 10.0;

class ComponentDecoration extends StatefulWidget {
  const ComponentDecoration({
    super.key,
    required this.label,
    required this.child,
    this.tooltipMessage = '',
  });

  final String label;
  final Widget child;
  final String? tooltipMessage;

  @override
  State<ComponentDecoration> createState() => _ComponentDecorationState();
}

class _ComponentDecorationState extends State<ComponentDecoration> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: smallSpacing),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.label,
                    style: Theme.of(context).textTheme.titleMedium),
                Tooltip(
                  message: widget.tooltipMessage,
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(Icons.info_outline, size: 16)),
                ),
              ],
            ),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: widthConstraint),
              // Tapping within the a component card should request focus
              // for that component's children.
              child: Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                child: GestureDetector(
                  onTapDown: (_) {
                    focusNode.requestFocus();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 20.0),
                      child: Center(
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Button Widget
class OpenDoorButton extends StatelessWidget {
  // Function to make the POST request
  Future<void> makePostRequest() async {
    // Define the URL and body data
    final url = Uri.parse("https://example.com/api/data");
    final body = jsonEncode({
      "key1": "value1",
      "key2": "value2",
    });

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        print("Success: ${response.body}");
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ComponentDecoration(
      label: 'Controls',
      tooltipMessage:
          'Use these to control the FishBox door and pumps',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: smallSpacing,
        spacing: 128.0,
        children: [
          // FloatingActionButton.small(
          //   onPressed: () {},
          //   tooltip: 'Small',
          //   child: const Icon(Icons.add),
          // ),
          // FloatingActionButton.extended(
          //   onPressed: () {},
          //   tooltip: 'Extended',
          //   icon: const Icon(Icons.add),
          //   label: const Text('Create'),
          // ),
          // FloatingActionButton(
          //   onPressed: () {},
          //   tooltip: 'Standard',
          //   child: const Icon(Icons.add),
          // ),
          Column(
            children: [
              Text('Open Door'), // Text above the button
              const SizedBox(height: 4), // Space between text and button
              Tooltip(
                message: 'Open FishBoxDoor',
                child: FloatingActionButton.large(
                  onPressed: makePostRequest,
                  child: const Icon(Icons.door_sliding),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text('Activate Pumps'), // Text above the button
              const SizedBox(height: 4), // Space between text and button
              Tooltip(
                message: 'Activate Pumps',
                child: FloatingActionButton.large(
                  onPressed: makePostRequest,
                  child: const Icon(Icons.water),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

