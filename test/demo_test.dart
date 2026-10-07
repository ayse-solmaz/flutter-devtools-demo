import 'package:debug_demo/main.dart';
import 'package:debug_demo/hesap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('%20 indirim 400 TL için 320 TL verir', () {
    expect(indirimliFiyat(400, 20), 320);
  });

  testWidgets('Ana menüden sepete gidilir, indirim 320 TL yapar',
      (tester) async {
    await tester.pumpWidget(const SunumApp());
    await tester.tap(find.text('Sepet'));
    await tester.pumpAndSettle();

    expect(find.text('Toplam: 400 TL'), findsOneWidget);
    await tester.tap(find.byKey(const Key('indirim')));
    await tester.pump();
    expect(find.text('Toplam: 320 TL'), findsOneWidget);
  });
}
