## 0.2.0

- Added `client.identities` (`list`, `get`, `update`, `delete`) matching current REST API v1.
- Deprecated `client.accounts` in favor of `client.identities`.
- Added `client.emails.update()` and `client.emails.cancel()` for scheduled emails.
- Added optional `scheduledAt` support in `client.emails.send()`.
- Fixed type mismatch in `client.batch.send` and transport allowing `List<Map<String, dynamic>>` payloads.
- Enforced curly braces in control flow structures to conform with Dart style guidelines.
- Updated documentation and API reference links to `docs.mailofly.com`.

## 0.1.2

- Point `repository` / `issue_tracker` at [teamredevs/mailofly-dart](https://github.com/teamredevs/mailofly-dart).
- Docs and homepage links use docs.mailofly.com.

## 0.1.1

- `MailoflyCompose.send` now uses named parameters (`accountKey`, `subject`, `body`, `to`, `toList`, `contactIds`, `cc`, `bcc`, `variables`, `templateId`) instead of a raw map. Use `sendRaw` for the previous escape hatch.

## 0.1.0

- Initial release: `Mailofly` client with accounts, contacts, templates, segments (including segment contacts), campaigns (runs & send), compose, and mail logs.
- `Mailofly.discovery()` for unauthenticated `GET /api/v1`.
- `MailoflyException` for API errors.
