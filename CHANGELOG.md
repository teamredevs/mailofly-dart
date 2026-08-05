## 0.1.2

- Point `repository` / `issue_tracker` at [teamredevs/mailofly-dart](https://github.com/teamredevs/mailofly-dart).
- Docs and homepage links use docs.mailofly.com.

## 0.1.1

- `MailoflyCompose.send` now uses named parameters (`accountKey`, `subject`, `body`, `to`, `toList`, `contactIds`, `cc`, `bcc`, `variables`, `templateId`) instead of a raw map. Use `sendRaw` for the previous escape hatch.

## 0.1.0

- Initial release: `Mailofly` client with accounts, contacts, templates, segments (including segment contacts), campaigns (runs & send), compose, and mail logs.
- `Mailofly.discovery()` for unauthenticated `GET /api/v1`.
- `MailoflyException` for API errors.
