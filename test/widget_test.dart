import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantrychef/main.dart';

void main() {
  testWidgets('PantryChefApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PantryChefApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    // Advance past splash animation and delay
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump(const Duration(milliseconds: 500));
  });
}

