import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobility_app/app/app.dart';
import 'package:mobility_app/utils/integration_test_helpers/mock.dart';
import 'package:mobility_app/utils/service_locator.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    setUpServicesLocator(
      isProductionForTartuBikesLink: false,
      isProductionForBoltScooterLink: false,
      isProductionForGtfsLink: false,
      isProductionForBoltHeader: false,
      isProductionForTuulScooterLink: false,
      isProductionForGeolocation: false,
    );
    await Firebase.initializeApp();
  });

  group(
    'app test',
    () {
      testWidgets(
        'pass the intro',
        (tester) async {
          await tester.pumpWidget(
            const MyApp(
              locale: Locale('en'),
            ),
          );
          await tester.pumpAndSettle();
          await getPastIntro(tester);
        },
      );
      testWidgets(
        'pass the onboarding',
        (tester) async {
          await tester.pumpWidget(
            const MyApp(
              locale: Locale('en'),
            ),
          );
          await tester.pump(const Duration(seconds: 1));
          await getPastOnboarding(tester);
        },
      );
      testWidgets(
        'change some settings',
        (tester) async {
          await tester.pumpWidget(
            const MyApp(
              locale: Locale('en'),
            ),
          );
          await tester.pump(const Duration(seconds: 1));
          await tester.pumpAndSettle();
          await tester.pump(const Duration(seconds: 2));
          final settingsIconButton = find.byKey(const Key('settings_icon_button'));
          await tester.tap(settingsIconButton);
          await tester.pump(const Duration(seconds: 1));
          final darkModeSwitch = find.byKey(const Key('dark_mode_switcher'));
          await tester.tap(darkModeSwitch);
          await tester.pump(const Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 1));
          final showTripsForTodayDropdown = find.byKey(const Key('show_trips_for_today_dropdown'));
          await tester.tap(showTripsForTodayDropdown);
          await tester.pump(const Duration(seconds: 1));
          await tester.pump(const Duration(seconds: 1));
          final showTripsForTodayDropdownToday = find.byKey(const Key('show_trips_for_today_dropdown_today'));
          await tester.tap(showTripsForTodayDropdownToday);
          await tester.pump(const Duration(seconds: 1));
        },
      );
    },
  );
}

Future<void> getPastIntro(WidgetTester tester) async {
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
  await tester.tap(navigateNext); //5-6
  await tester.pumpAndSettle();
  await tester.tap(navigateNext); //6-7
  await tester.pumpAndSettle();
  final doneButton = find.byKey(const Key('intro_done_button'));
  await tester.tap(doneButton);
  await tester.pump(const Duration(seconds: 1));
}

Future<void> getPastOnboarding(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  final onSt = find.byType(OnboardingStepper);
  await tester.tap(onSt);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(onSt);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(onSt);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(onSt);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  await tester.tap(onSt);
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}
