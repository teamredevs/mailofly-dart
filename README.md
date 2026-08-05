# mailofly

[![pub package](https://img.shields.io/pub/v/mailofly.svg)](https://pub.dev/packages/mailofly)

Official **Dart / Flutter** client for the [Mailofly REST API](https://docs.mailofly.com/api).

> **Source of truth:** developed in the [mailofly monorepo](https://github.com/redevs/mailofly) under `packages/dart`. This public repo is mirrored automatically on change.

## Requirements

- Dart **3.0** or newer (Flutter compatible).

## Install

```yaml
dependencies:
  mailofly: ^0.1.1
```

```bash
dart pub add mailofly
```

## Usage

Create a client with your API key from [**User → API keys**](https://www.mailofly.com/user/api-keys):

```dart
import 'package:mailofly/mailofly.dart';

Future<void> main() async {
  final client = Mailofly(apiKey: 'mf_live_…');

  try {
    final accounts = await client.accounts.list();
    print(accounts['data']);

    await client.compose.send(
      accountKey: 'acc_…',
      subject: 'Hi {{first_name}}',
      body: '<p>Thanks for signing up.</p>',
      to: 'you@example.com',
      // or: toList: ['a@b.com', 'c@d.com'],
      // or: contactIds: ['uuid-…'],
      cc: ['cc@example.com'],
      bcc: ['bcc@example.com'],
      variables: {'first_name': 'Alex'},
    );
  } on MailoflyException catch (e) {
    print('${e.statusCode} ${e.error} ${e.message}');
  } finally {
    client.close();
  }
}
```

### Discovery (no API key)

```dart
final meta = await Mailofly.discovery();
print(meta['resources']);
```

### Resources

| API | Dart |
|-----|------|
| Accounts | `client.accounts.list()`, `create`, `get`, `update`, `delete` |
| Contacts | `client.contacts.list(segmentId: …)`, `create`, `get`, `update`, `delete` |
| Templates | `client.templates.list()`, … |
| Segments | `client.segments.list()`, … plus `client.segments.contacts(id).list/add/remove` |
| Campaigns | `client.campaigns.list()`, …, `runs`, `send` |
| Compose | `client.compose.send(accountKey: …, subject: …, body: …, to: …)` or `sendRaw` |
| Mail logs | `client.mailLogs.list(page: 1, pageSize: 20, status: 'sent')` |

Request/response JSON matches [`/api/v1`](https://docs.mailofly.com/api).

### Custom base URL & HTTP client

```dart
final client = Mailofly(
  apiKey: 'mf_live_…',
  baseUrl: 'https://www.mailofly.com',
  httpClient: myClient, // optional; default closes when you call client.close()
);
```

## Docs

- [SDK overview](https://docs.mailofly.com/sdks)
- [Dart guide](https://docs.mailofly.com/sdks/dart)
- [API reference](https://docs.mailofly.com/api)

## Releasing

1. Bump `version` in `pubspec.yaml` (and `CHANGELOG.md`) in the **monorepo** PR.
2. Merge to `main`/`master` → GitHub Action syncs this folder to `redevs/mailofly-dart`.
3. Publish workflow runs and publishes to pub.dev only when the version is new.

## License

MIT
