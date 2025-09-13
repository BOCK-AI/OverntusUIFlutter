// In test/widget_test.dart

// These two imports are for the testing framework itself.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
// THIS IS THE MISSING LINE:
// It tells this test file where to find the 'MyApp' widget.
// IMPORTANT: Replace 'orventus_web' with your actual package name from pubspec.yaml

void main() {
  testWidgets('App starts and redirects to LoginPage for a logged-out user', (WidgetTester tester) async {
    // Step 1: Build our app. It will start at the AuthCheckPage.
    await tester.pumpWidget(const OrventusApp());

    // Initially, we should see the loading spinner from AuthCheckPage
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Step 2: Wait for all timers and navigations to complete.
    await tester.pumpAndSettle();

    // Step 3: Verify that we have been successfully redirected to the LoginPage.
    expect(find.widgetWithText(ElevatedButton, 'Continue'), findsOneWidget);

    // We can also verify that the loading spinner is gone.
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}