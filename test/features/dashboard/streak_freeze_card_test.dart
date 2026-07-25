import 'package:echomirror/features/dashboard/view/widgets/mood_streak_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoodStreakCard - freeze button', () {
    testWidgets('shows freeze button when showFreezeButton is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MoodStreakCard(
              streak: 5,
              showFreezeButton: true,
              onFreezeTap: null,
            ),
          ),
        ),
      );

      expect(find.text('\u{1F525} 5-day streak'), findsOneWidget);
      expect(find.text('Protect my streak (5 ECHO)'), findsOneWidget);
    });

    testWidgets('hides freeze button when showFreezeButton is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MoodStreakCard(
              streak: 5,
              showFreezeButton: false,
              onFreezeTap: null,
            ),
          ),
        ),
      );

      expect(find.text('\u{1F525} 5-day streak'), findsOneWidget);
      expect(find.text('Protect my streak (5 ECHO)'), findsNothing);
    });

    testWidgets('hides freeze button when streak is 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MoodStreakCard(
              streak: 0,
              showFreezeButton: false,
              onFreezeTap: null,
            ),
          ),
        ),
      );

      expect(find.text('\u{1F525} 0-day streak'), findsOneWidget);
      expect(find.text('Start your streak today!'), findsOneWidget);
      expect(find.text('Protect my streak (5 ECHO)'), findsNothing);
    });
  });

  group('Freeze confirmation dialog', () {
    testWidgets('cancel button dismisses the dialog', (tester) async {
      bool dialogVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => dialogVisible = !dialogVisible),
                      child: const Text('Toggle'),
                    ),
                    if (dialogVisible)
                      GestureDetector(
                        onTap: () => setState(() => dialogVisible = false),
                        child: Container(color: Colors.black54),
                      ),
                    if (dialogVisible)
                      Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Protect your streak'),
                                const Text('Spend 5 ECHO'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          setState(() => dialogVisible = false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () {},
                                      child: const Text('Freeze it'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Toggle'));
      await tester.pump();

      expect(find.text('Protect your streak'), findsOneWidget);
      expect(find.text('Spend 5 ECHO'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Freeze it'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(find.text('Protect your streak'), findsNothing);
    });
  });
}
