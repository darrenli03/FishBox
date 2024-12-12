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
  const BoxState({super.key});

  @override
  _BoxCurrentState createState() => _BoxCurrentState();
}

class _BoxCurrentState extends State<BoxState> {
  bool isManualOverrideOn = false; // Track manual override state
  bool isBackPumpsOn = false; // Track back pumps state
  bool isFrontPumpsOn = false; // Track front pumps state
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

  // Function to toggle manual override state with a GET request
  Future<void> toggleManualOverride() async {
    // final url = Uri.parse("http://10.194.27.154:8000/manual_override?state=${isManualOverrideOn ? "off" : "on"}");
    final url = Uri.parse("http://10.194.27.154:8000/toggle_manual_mode");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          isManualOverrideOn = !isManualOverrideOn;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update manual override state: ${response}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update manual override state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to toggle back pumps state with a GET request
  Future<void> toggleBackPumps() async {
    // final url = Uri.parse("http://10.194.27.154:8000/back_pumps?state=${isBackPumpsOn ? "off" : "on"}");
    final url = Uri.parse("http://10.194.27.154:8000/toggle_pump_1");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          isBackPumpsOn = !isBackPumpsOn;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update back pumps state: ${response}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update back pumps state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to toggle front pumps state with a GET request
  Future<void> toggleFrontPumps() async {
    // final url = Uri.parse("http://10.194.27.154:8000/front_pumps?state=${isFrontPumpsOn ? "off" : "on"}");
    final url = Uri.parse("http://10.194.27.154:8000/toggle_pump_2");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          isFrontPumpsOn = !isFrontPumpsOn;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update front pumps state: ${response}';
          errorMessageOpacity = 1.0;
        });
        clearErrorMessage(); // Clear the error message after 5 seconds
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to update front pumps state: $e';
        errorMessageOpacity = 1.0;
      });
      clearErrorMessage(); // Clear the error message after 5 seconds
    }
  }

  // Function to toggle door state with a GET request
  Future<void> toggleDoor() async {
    // final url = Uri.parse("http://10.194.27.154:8000/door?state=${isDoorOpen ? "close" : "open"}");
    final url = Uri.parse("http://10.194.27.154:8000/toggle_door");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          isDoorOpen = !isDoorOpen;
          errorMessage = ''; // Clear error message on success
          errorMessageOpacity = 0.0;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to update door state: ${response}';
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
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: widthConstraint,
              padding: const EdgeInsets.all(8.0),
              color: Colors.redAccent,
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Manual Override'),
                  Switch(
                    value: isManualOverrideOn,
                    onChanged: (value) => toggleManualOverride(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Back Pumps'),
                  Switch(
                    value: isBackPumpsOn,
                    onChanged: (value) => toggleBackPumps(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Front Pumps'),
                  Switch(
                    value: isFrontPumpsOn,
                    onChanged: (value) => toggleFrontPumps(),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('Door'),
                  Switch(
                    value: isDoorOpen,
                    onChanged: (value) => toggleDoor(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
