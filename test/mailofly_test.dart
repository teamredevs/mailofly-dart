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

  test('Mailofly exposes automations and events resources', () {
    final client = Mailofly(apiKey: 'mf_live_test');
    expect(client.automations, isNotNull);
    expect(client.automations.runs, isNotNull);
    expect(client.events, isNotNull);
    client.close();
  });
}

