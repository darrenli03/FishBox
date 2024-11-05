// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'settings/settings_controller.dart';
// import 'settings/settings_view.dart';
import 'widgets/flutter_mjpeg.dart';
import 'widgets/opendoorbutton.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            // appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
            body: Column(
              children: [
                Expanded(child: MjpegStreamPage(settingsController: settingsController)), 
                OpenDoorButton(), // Add OpenDoorButton widget here
              ],
            ),
            // body: MjpegStreamPage(settingsController: settingsController) // Replace the Column widget with the mjpegStreamPage function
          ),
        );
      },
    );
  }
}
