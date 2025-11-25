// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab1_basic_ui/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: This test requires Supabase to be initialized, 
    // but the app will handle initialization errors gracefully
    await tester.pumpWidget(const FitnessClubApp());

    // Verify that the app loads (we expect AuthScreen if not authenticated)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
