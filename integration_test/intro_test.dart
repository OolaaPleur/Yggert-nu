import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobility_app/app/app.dart';
import 'package:mobility_app/utils/service_locator.dart';

void main() {
  // This will run before any test is executed.
  setUpAll(() {
    setUpServicesLocator(
      isProductionForTartuBikesLink: false,
      isProductionForBoltScooterLink: false,
      isProductionForGtfsLink: false,
      isProductionForTuulScooterLink: false,
      isProductionForGeolocation: false,
      isProductionHoogScooterLink: false,
      isProductionBoltCarsLink: false,
    );
  });
  group('intro test', () {
    testWidgets('tap on arrows, verify intro screen could be changed', (tester) async {
      await tester.pumpWidget(
        const MyApp(
          locale: Locale('en'),
        ),
      );
      await tester.pumpAndSettle();
      final navigateNext = find.byIcon(Icons.navigate_next);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      await tester.tap(navigateNext); //1-2
      await tester.pumpAndSettle();
      final navigateBefore = find.byIcon(Icons.navigate_before);
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_before), findsOneWidget);
      await tester.tap(navigateNext); //2-3
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_before), findsOneWidget);
      await tester.tap(navigateNext); //3-4
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_before), findsOneWidget);
      await tester.tap(navigateBefore); //4-3
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.navigate_next), findsOneWidget);
      expect(find.byIcon(Icons.navigate_before), findsOneWidget);
    });
    testWidgets('change city on second intro screen', (tester) async {
      await tester.pumpWidget(
        const MyApp(
          locale: Locale('en'),
        ),
      );
      await tester.pumpAndSettle();
      final navigateNext = find.byIcon(Icons.navigate_next);
      await tester.pumpAndSettle();
      await tester.tap(navigateNext); //1-2
      await tester.pumpAndSettle();
      final dropdownFinder = find.byKey(const Key('intro_dropdown_button'));
      expect(dropdownFinder, findsOneWidget);
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();
      final scrollableFinder = find.byType(ListView);
      await tester.pump(const Duration(seconds: 1));
      final itemFinder = find.text('Narva');

      await tester.dragUntilVisible(
        itemFinder,
        scrollableFinder,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(itemFinder);
      await tester.pumpAndSettle();
      // Get the dropdown widget from the tree and check its current value
      final dropdown = tester.widget<DropdownButton<String>>(dropdownFinder);
      expect(dropdown.value, equals('narva'));
    });
    testWidgets('change theme', (tester) async {
      await tester.pumpWidget(
        const MyApp(
          locale: Locale('en'),
        ),
      );
      await tester.pumpAndSettle();
      final navigateNext = find.byIcon(Icons.navigate_next);
      await tester.pumpAndSettle();
      await tester.tap(navigateNext); //1-2
      await tester.pumpAndSettle();
      await tester.tap(navigateNext); //2-3
      await tester.pumpAndSettle();
      await tester.tap(navigateNext); //3-4
      await tester.pumpAndSettle();
      await tester.tap(navigateNext); //4-5
      await tester.pumpAndSettle();
      final changeThemeButtonFinder = find.byKey(const Key('intro_change_theme_button'));
      await tester.tap(changeThemeButtonFinder);
      await tester.pumpAndSettle();

      final textFinder = find.text('Customize to Your Liking');
      final textElement = tester.element(textFinder);
      final themeData = Theme.of(textElement);

// Check if the theme is dark
      expect(themeData.brightness, equals(Brightness.dark));
    });
  });
}
