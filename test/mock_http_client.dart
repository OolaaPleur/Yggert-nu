import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobility_app/bolt_scooters.dart';
import 'package:mobility_app/main.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets('fetchData returns data if the http call completes successfully',
      (WidgetTester tester) async {
    final client = MockClient();
    when(client.get(
            Uri.parse('https://dummyjson.com/products/1')))
        .thenAnswer((_) async => http.Response('', 200));
    await tester.pumpWidget(const MyApp());

    // Expect that your function fetchData will use the mocked client and
    // return the sample data provided in the mocked response.
    expect(find.byIcon(Icons.electric_scooter), findsOneWidget);
    expect(find.byIcon(Icons.pedal_bike_sharp), findsOneWidget);
  });

  // // Handle failure scenarios.
  // test('fetchData throws an exception if the http call completes with an error', () async {
  //   when(client.get('https://api.com/data'))
  //       .thenAnswer((_) async => http.Response('Not Found', 404));
  //
  //   expect(fetchData(client), throwsException);
  // });
}
