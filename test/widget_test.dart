
import 'package:flutter_test/flutter_test.dart';
import 'package:cipher_lab/main.dart';

void main() {
  testWidgets('CipherLab application loads', (WidgetTester tester) async {
    await tester.pumpWidget(const CipherLabApp());

    expect(find.text('CipherLab'), findsOneWidget);
    expect(find.text('Transform your message.'), findsOneWidget);
    expect(find.text('Input Text'), findsOneWidget);
    expect(find.text('Output Text'), findsOneWidget);
    expect(find.text('Encrypt'), findsOneWidget);
    expect(find.text('Decrypt'), findsOneWidget);
  });
}
