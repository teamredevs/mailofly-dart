import 'package:mailofly/mailofly.dart';
import 'package:test/test.dart';

void main() {
  test('Mailofly rejects empty apiKey', () {
    expect(
      () => Mailofly(apiKey: ''),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => Mailofly(apiKey: '   '),
      throwsA(isA<ArgumentError>()),
    );
  });
}
