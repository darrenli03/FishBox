import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import the dart:async package for Timer

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

class BoxState extends StatefulWidget {
  @override
  _BoxCurrentState createState() => _BoxCurrentState();
}

class _BoxCurrentState extends State<BoxState> {
  bool isPumpOn = false; // Track pump state
  bool isDoorOpen = false; // Track door state
  String errorMessage = ''; // Track error message
  double errorMessageOpacity = 0.0;
  Timer? _errorTimer;

  // Function to clear the error message after 5 seconds
  void clearErrorMessage() {
    _errorTimer?.cancel(); // Cancel any existing timer
    _errorTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        errorMessageOpacity = 0.0;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          errorMessage = '';
        });
      });
    });
  }

  // Function to toggle pump state with a PUT request
  Future<void> togglePumpState() async {
    final url = Uri.parse("https://example.com/api/pump");
    final newState = isPumpOn ? "off" : "on";
    final body = jsonEncode({"state": newState});

    try {
      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          isPumpOn = !isPumpOn;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update pump state: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update pump state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to toggle door state with a PUT request
  Future<void> toggleDoorState() async {
    final url = Uri.parse("https://example.com/api/door");
    final newState = isDoorOpen ? "closed" : "open";
    final body = jsonEncode({"state": newState});

    try {
      final response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          isDoorOpen = !isDoorOpen;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update door state: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update door state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return ComponentDecoration(
      label: 'Controls',
      tooltipMessage: 'Use these to control the FishBox door and pumps',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: smallSpacing,
        spacing: 128.0,
        children: [
          AnimatedOpacity(
            opacity: errorMessageOpacity,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: widthConstraint,
              padding: const EdgeInsets.all(8.0),
              color: Colors.redAccent,
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 4),
              Tooltip(
                message: isDoorOpen ? 'Close Door' : 'Open Door',
                child: SwitchListTile(
                  title: Text(isDoorOpen ? "Door Open" : "Door Closed"),
                  value: isDoorOpen,
                  onChanged: (value) => toggleDoorState(),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 4),
              Tooltip(
                message: isPumpOn ? 'Turn off Pump' : 'Turn on Pump',
                child: SwitchListTile(
                  title: Text(isPumpOn ? "Pump On" : "Pump Off"),
                  value: isPumpOn,
                  onChanged: (value) => togglePumpState(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}