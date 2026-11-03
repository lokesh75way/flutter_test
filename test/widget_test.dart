import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task/main.dart';
import 'package:task/widgets/input_box.dart';

void main() {
  testWidgets('create account button is enabled only for a valid form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('* Mobile number (ex: 5********)'), findsOneWidget);

    final button = find.ancestor(
      of: find.text('Create my account'),
      matching: find.byType(InkWell),
    );
    expect(tester.widget<InkWell>(button).onTap, isNull);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(7));

    await tester.enterText(fields.at(0), 'Michell');
    await tester.enterText(fields.at(1), 'Doe');
    await tester.enterText(fields.at(2), '512345678');
    await tester.enterText(fields.at(4), 'michell@abc.com');
    await tester.enterText(fields.at(5), 'password1');
    await tester.enterText(fields.at(6), 'password1');
    await tester.pump();

    // everything is filled but the terms are not accepted yet
    expect(tester.widget<InkWell>(button).onTap, isNull);

    // the checkbox is the last InputBox on the screen
    await tester.tap(find.byType(InputBox).last);
    await tester.pump();

    expect(tester.widget<InkWell>(button).onTap, isNotNull);
  });
}
