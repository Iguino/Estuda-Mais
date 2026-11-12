import 'package:flutter_test/flutter_test.dart';
import 'package:estuda_mais/main.dart';

void main() {
  testWidgets('Verifica se o aplicativo Estuda+ inicia',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EstudaMaisApp());

    expect(find.text('Estuda+'), findsOneWidget);
  });
}