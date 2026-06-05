import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runzone/app/run_zone_app.dart';

void main() {
  testWidgets('앱 이름을 화면과 title에 표시한다', (WidgetTester tester) async {
    // Given
    const app = RunZoneApp();

    // When
    await tester.pumpWidget(app);

    // Then
    expect(find.text('Run Zone'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Run Zone');
  });
}
