import 'package:mailofly/mailofly.dart';
import 'package:test/test.dart';

void main() {
  group('buildEmailsRequestBody', () {
    test('standard email payload', () {
      final m = buildEmailsRequestBody(
        from: 'Acme <onboarding@example.com>',
        to: ['user@example.com'],
        subject: 'Welcome',
        html: '<p>Hello world</p>',
        accountKey: 'acc_123',
        tags: [
          {'name': 'category', 'value': 'welcome'},
        ],
      );

      expect(m['from'], 'Acme <onboarding@example.com>');
      expect(m['to'], ['user@example.com']);
      expect(m['subject'], 'Welcome');
      expect(m['html'], '<p>Hello world</p>');
      expect(m['account_key'], 'acc_123');
      expect(m['tags'], [
        {'name': 'category', 'value': 'welcome'},
      ]);
    });

    test('template payload', () {
      final m = buildEmailsRequestBody(
        from: 'Acme <onboarding@example.com>',
        to: 'user@example.com',
        template: {
          'id': 'tpl_abc',
          'variables': {'name': 'Alex'},
        },
      );

      expect(m['from'], 'Acme <onboarding@example.com>');
      expect(m['to'], 'user@example.com');
      expect(m['template'], {
        'id': 'tpl_abc',
        'variables': {'name': 'Alex'},
      });
    });
  });

  group('buildComposeRequestBody', () {
    test('inline + to', () {
      final m = buildComposeRequestBody(
        accountKey: 'acc_x',
        subject: 'Hi',
        body: '<p>x</p>',
        to: 'a@b.com',
      );
      expect(m['account_key'], 'acc_x');
      expect(m['subject'], 'Hi');
      expect(m['html'], '<p>x</p>');
      expect(m['to'], 'a@b.com');
    });

    test('template + variables', () {
      final m = buildComposeRequestBody(
        accountKey: 'acc_x',
        templateId: 'tid',
        to: 'a@b.com',
        variables: {'first_name': 'Sam'},
      );
      expect(m['account_key'], 'acc_x');
      expect(m['template'], {
        'id': 'tid',
        'variables': {'first_name': 'Sam'},
      });
    });

    test('cc and bcc', () {
      final m = buildComposeRequestBody(
        accountKey: 'acc_x',
        subject: 'S',
        body: '<p>b</p>',
        to: 'a@b.com',
        cc: ['c@c.com'],
        bcc: ['d@d.com'],
      );
      expect(m['cc'], ['c@c.com']);
      expect(m['bcc'], ['d@d.com']);
      expect(m['to'], 'a@b.com');
    });
  });
}
