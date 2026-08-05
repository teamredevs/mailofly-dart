import 'package:mailofly/mailofly.dart';
import 'package:test/test.dart';

void main() {
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
      expect(m['body'], '<p>x</p>');
      expect(m['recipients'], {'emails': ['a@b.com']});
    });

    test('template + contactIds', () {
      final m = buildComposeRequestBody(
        accountKey: 'acc_x',
        templateId: 'tid',
        contactIds: ['u1'],
      );
      expect(m['template_id'], 'tid');
      expect(m['recipients'], {
        'type': 'contacts',
        'contact_ids': ['u1'],
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
    });
  });
}
