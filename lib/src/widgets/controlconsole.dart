import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
  String doorStateMessage = 'Unknown'; // Track door state message

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
  // Future<void> togglePumpState() async {
  //   //TODO: change to pump state url when implemented
  //   final url = Uri.parse("http://10.42.0.1:8000/stream.mjpg");
  //   final newState = isPumpOn ? "off" : "on";
  //   final body = jsonEncode({"state": newState});

  //   try {
  //     final response = await http.put(url, body: body, headers: {
  //       'Content-Type': 'application/json',
  //     });

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         isPumpOn = !isPumpOn;
  //         errorMessage = ''; // Clear error message on success
  //         errorMessageOpacity = 0.0;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = 'Failed to update pump state: ${response.reasonPhrase}';
  //         errorMessageOpacity = 1.0;
  //       });
  //       clearErrorMessage(); // Clear the error message after 5 seconds
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to update pump state: $e';
  //       errorMessageOpacity = 1.0;
  //     });
  //     clearErrorMessage(); // Clear the error message after 5 seconds
  //   }
  // }

  // Function to fetch the current door state
  Future<void> fetchDoorState() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.42.0.1:8000/get_status'));
          // await http.get(Uri.parse('http://10.146.90.63:8000/get_status'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          isDoorOpen = jsonResponse['isOpened'];
          doorStateMessage = isDoorOpen ? 'Open' : 'Closed';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch door state: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch door state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to override door open state with a get request
  Future<void> overrideDoorOpen() async {
    // final url = Uri.parse("http://1.42.0.1:8000/overrideOpen");
    final url = Uri.parse("http://10.146.90.63:8000/overrideOpen");

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          isDoorOpen = true;
          doorStateMessage = 'Open';
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to override door open: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to override door open: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to override door close state with a get request
  Future<void> overrideDoorClose() async {
    final url = Uri.parse("http://10.42.0.1:8000/overrideClosed");
    // final url = Uri.parse("http://10.146.90.63:8000/overrideClosed");

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          isDoorOpen = false;
          doorStateMessage = 'Closed';
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to override door close: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to override door close: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to disable door override with a get request
  Future<void> disableOverride() async {
    final url = Uri.parse("http://10.42.0.1:8000/disableOverride");
    // final url = Uri.parse("http://10.146.90.63:8000/resetOverride");
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to disable override: ${response.reasonPhrase}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to disable override: $e';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              Text('Current Door State: $doorStateMessage'),
              ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
            ElevatedButton(
              onPressed: disableOverride,
              child: Text('Disable Override'),
            ),
          ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: overrideDoorOpen,
                child: Text('Open Door'),
              ),
              ElevatedButton(
                onPressed: overrideDoorClose,
                child: Text('Close Door'),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     const SizedBox(height: 4),
          //     Tooltip(
          //       message: isDoorOpen ? 'Close Door' : 'Open Door',
          //       child: SwitchListTile(
          //         title: Text(isDoorOpen ? "Door Open" : "Door Closed"),
          //         value: isDoorOpen,
          //         onChanged: (value) => toggleDoorState(),
          //       ),
          //     ),
          //   ],
          // ),
          // Commented out pump controls
          // Column(
          //   children: [
          //     const SizedBox(height: 4),
          //     Tooltip(
          //       message: isPumpOn ? 'Turn off Pump' : 'Turn on Pump',
          //       child: SwitchListTile(
          //         title: Text(isPumpOn ? "Pump On" : "Pump Off"),
          //         value: isPumpOn,
          //         onChanged: (value) => togglePumpState(),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
