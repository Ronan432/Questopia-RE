import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:questopia_re/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // The onboarding gate only opens the library on a fresh install, so the
    // tests mark the setup as finished to reach the screens under test.
    SharedPreferences.setMockInitialValues({
      'pref_onboarding_completed': true,
    });
  });

  testWidgets('library screen renders both tabs and app bar actions',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: QuestopiaApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Questopia'), findsWidgets);
    // The first bottom-bar destination is labelled "Home"; "Catalog" is the
    // second. The app bar title mirrors the selected tab.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.byTooltip('Import game'), findsOneWidget);
    expect(find.byTooltip('Settings'), findsOneWidget);
  });

  testWidgets('settings screen opens with theme and accent rows',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: QuestopiaApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    // "Settings" shows both as the app-bar title and as the third bottom-bar
    // destination label, so more than one match is expected.
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Appearance'), findsWidgets);
    expect(find.text('Color accent'), findsOneWidget);

    await tester.tap(find.text('General').first);
    await tester.pumpAndSettle();

    expect(find.text('Immersive mode'), findsOneWidget);

    await tester.ensureVisible(find.text('Storage').first);
    await tester.tap(find.text('Storage').first);
    await tester.pumpAndSettle();

    expect(find.text('Storage'), findsWidgets);
    expect(find.text('Games folder'), findsOneWidget);
  });
}
