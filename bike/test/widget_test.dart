import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bikers/main.dart';
import 'package:bikers/providers/bike_provider.dart';
import 'package:bikers/providers/ride_provider.dart';
import 'package:bikers/providers/squad_provider.dart';
import 'package:bikers/screens/group_detail_screen.dart';
import 'package:bikers/screens/settings_screen.dart';
import 'package:bikers/theme/app_theme.dart';

void main() {
  testWidgets('Bike Squad app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SquadProvider()),
          ChangeNotifierProvider(create: (_) => BikeProvider()),
          ChangeNotifierProvider(create: (_) => RideSetup()),
          ChangeNotifierProvider(create: (_) => AppTheme()),
        ],
        child: const BikeSquadApp(),
      ),
    );

    expect(find.byType(BikeSquadApp), findsOneWidget);
    expect(find.text('Bike Squad'), findsWidgets);
  });

  testWidgets('Settings screen exposes a theme switch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SquadProvider()),
          ChangeNotifierProvider(create: (_) => BikeProvider()),
          ChangeNotifierProvider(create: (_) => RideSetup()),
          ChangeNotifierProvider(create: (_) => AppTheme()),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    expect(find.text('Theme'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('Group detail screen shows the group call entry point', (
    WidgetTester tester,
  ) async {
    final squad = SquadProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider<SquadProvider>.value(value: squad)],
        child: MaterialApp(
          home: GroupDetailScreen(groupId: squad.groups.first.id),
        ),
      ),
    );

    expect(find.byIcon(Icons.videocam), findsOneWidget);

    await tester.tap(find.byIcon(Icons.videocam));
    await tester.pumpAndSettle();

    expect(find.text('Start Group Call'), findsOneWidget);
  });
}
