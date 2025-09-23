import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../lib/main.dart';
import '../lib/screens/profile_page.dart';
import '../lib/screens/dashboard_mobile.dart';

void main() {
  testWidgets('Orventus login flow test (generic)', (WidgetTester tester) async {
    // Build the Orventus app
    await tester.pumpWidget(const OrventusApp());

    // Verify landing page has Orventus branding
    expect(find.textContaining('Orventus'), findsWidgets);

    // Tap the "Login" button in the navbar/hero
    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Now we should be on the LoginPage
    expect(find.text('Login to Orventus'), findsOneWidget);

    // Enter dummy email + password
    await tester.enterText(find.byType(TextFormField).at(0), 'test@orventus.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap login submit
    await tester.tap(find.text('Login'));
    await tester.pump(); // show SnackBar
    expect(find.text('Login successful!'), findsOneWidget);

    // Wait for redirect
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify Dashboard loaded (web or mobile depending on kIsWeb)
    if (kIsWeb) {
      expect(find.byType(DashboardWeb), findsOneWidget);
    } else {
      expect(find.byType(DashboardMobile), findsOneWidget);
    }
  });

  testWidgets('Orventus DashboardWeb loads correctly', (WidgetTester tester) async {
    // Force DashboardWeb screen
    await tester.pumpWidget(
      const MaterialApp(home: DashboardWeb(userType: 'rider')),
    );

    // Verify some content
    expect(find.textContaining('Dashboard'), findsOneWidget);
    expect(find.textContaining('rider'), findsWidgets);
  });

  testWidgets('Orventus DashboardMobile loads correctly', (WidgetTester tester) async {
    // Force DashboardMobile screen
    await tester.pumpWidget(
      const MaterialApp(home: DashboardMobile(userType: 'driver')),
    );

    // Verify some content
    expect(find.textContaining('Dashboard'), findsOneWidget);
    expect(find.textContaining('driver'), findsWidgets);
  });
}
