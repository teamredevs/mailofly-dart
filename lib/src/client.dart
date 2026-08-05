import 'package:http/http.dart' as http;

import 'compose.dart';
import 'transport.dart';

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw StateError('Expected JSON object, got ${value.runtimeType}');
}

String _requireApiKey(String apiKey) {
  final k = apiKey.trim();
  if (k.isEmpty) {
    throw ArgumentError.value(apiKey, 'apiKey', 'Mailofly apiKey is required');
  }
  return k;
}

/// Dart client for Mailofly `/api/v1`.
///
/// Call [close] when done if you rely on the default HTTP client, or pass your own [http.Client].
class Mailofly {
  Mailofly({
    required String apiKey,
    String? baseUrl,
    http.Client? httpClient,
  }) : _transport = MailoflyTransport(
          baseUrl: normalizeBaseUrl(baseUrl ?? kDefaultBaseUrl),
          apiKey: _requireApiKey(apiKey),
          client: httpClient,
        );

  final MailoflyTransport _transport;

  /// Unauthenticated `GET /api/v1` discovery document.
  static Future<Map<String, dynamic>> discovery({
    String? baseUrl,
    http.Client? httpClient,
  }) async {
    final t = MailoflyTransport(
      baseUrl: normalizeBaseUrl(baseUrl ?? kDefaultBaseUrl),
      apiKey: '',
      client: httpClient,
    );
    try {
      final r = await t.request('GET', '', withAuth: false);
      return _asMap(r);
    } finally {
      t.close();
    }
  }

  MailoflyAccounts get accounts => MailoflyAccounts(_transport);

  MailoflyContacts get contacts => MailoflyContacts(_transport);

  MailoflyTemplates get templates => MailoflyTemplates(_transport);

  MailoflySegments get segments => MailoflySegments(_transport);

  MailoflyCampaigns get campaigns => MailoflyCampaigns(_transport);

  MailoflyCompose get compose => MailoflyCompose(_transport);

  MailoflyMailLogs get mailLogs => MailoflyMailLogs(_transport);

  void close() => _transport.close();
}

class MailoflyAccounts {
  MailoflyAccounts(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list() async => _asMap(await _t.request('GET', 'accounts'));

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'accounts', body: body));

  Future<Map<String, dynamic>> get(String id) async =>
      _asMap(await _t.request('GET', 'accounts/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) async =>
      _asMap(await _t.request('PATCH', 'accounts/${Uri.encodeComponent(id)}', body: body));

  Future<Map<String, dynamic>> delete(String id) async =>
      _asMap(await _t.request('DELETE', 'accounts/${Uri.encodeComponent(id)}'));
}

class MailoflyContacts {
  MailoflyContacts(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list({String? segmentId}) async {
    final q = segmentId == null ? null : <String, String>{'segment_id': segmentId};
    return _asMap(await _t.request('GET', 'contacts', query: q));
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'contacts', body: body));

  Future<Map<String, dynamic>> get(String id) async =>
      _asMap(await _t.request('GET', 'contacts/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) async =>
      _asMap(await _t.request('PATCH', 'contacts/${Uri.encodeComponent(id)}', body: body));

  Future<Map<String, dynamic>> delete(String id) async =>
      _asMap(await _t.request('DELETE', 'contacts/${Uri.encodeComponent(id)}'));
}

class MailoflyTemplates {
  MailoflyTemplates(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list() async => _asMap(await _t.request('GET', 'templates'));

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'templates', body: body));

  Future<Map<String, dynamic>> get(String id) async =>
      _asMap(await _t.request('GET', 'templates/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) async =>
      _asMap(await _t.request('PATCH', 'templates/${Uri.encodeComponent(id)}', body: body));

  Future<Map<String, dynamic>> delete(String id) async =>
      _asMap(await _t.request('DELETE', 'templates/${Uri.encodeComponent(id)}'));
}

class MailoflySegments {
  MailoflySegments(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list() async => _asMap(await _t.request('GET', 'segments'));

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'segments', body: body));

  Future<Map<String, dynamic>> get(String id) async =>
      _asMap(await _t.request('GET', 'segments/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) async =>
      _asMap(await _t.request('PATCH', 'segments/${Uri.encodeComponent(id)}', body: body));

  Future<Map<String, dynamic>> delete(String id) async =>
      _asMap(await _t.request('DELETE', 'segments/${Uri.encodeComponent(id)}'));

  MailoflySegmentContacts contacts(String segmentId) =>
      MailoflySegmentContacts(_t, segmentId);
}

class MailoflySegmentContacts {
  MailoflySegmentContacts(this._t, this.segmentId);
  final MailoflyTransport _t;
  final String segmentId;

  Future<Map<String, dynamic>> list() async => _asMap(
        await _t.request('GET', 'segments/${Uri.encodeComponent(segmentId)}/contacts'),
      );

  Future<Map<String, dynamic>> add(Map<String, dynamic> body) async => _asMap(
        await _t.request(
          'POST',
          'segments/${Uri.encodeComponent(segmentId)}/contacts',
          body: body,
        ),
      );

  Future<Map<String, dynamic>> remove(String contactId) async => _asMap(
        await _t.request(
          'DELETE',
          'segments/${Uri.encodeComponent(segmentId)}/contacts/${Uri.encodeComponent(contactId)}',
        ),
      );
}

class MailoflyCampaigns {
  MailoflyCampaigns(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list() async => _asMap(await _t.request('GET', 'campaigns'));

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'campaigns', body: body));

  Future<Map<String, dynamic>> get(String id) async =>
      _asMap(await _t.request('GET', 'campaigns/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) async =>
      _asMap(await _t.request('PATCH', 'campaigns/${Uri.encodeComponent(id)}', body: body));

  Future<Map<String, dynamic>> delete(String id) async =>
      _asMap(await _t.request('DELETE', 'campaigns/${Uri.encodeComponent(id)}'));

  Future<Map<String, dynamic>> runs(String id) async => _asMap(
        await _t.request('GET', 'campaigns/${Uri.encodeComponent(id)}/runs'),
      );

  Future<Map<String, dynamic>> send(
    String id, {
    Map<String, dynamic>? body,
  }) async =>
      _asMap(
        await _t.request(
          'POST',
          'campaigns/${Uri.encodeComponent(id)}/send',
          body: body ?? const {'send_now': true},
        ),
      );
}

class MailoflyCompose {
  MailoflyCompose(this._t);
  final MailoflyTransport _t;

  /// Sends one-off email via [POST /api/v1/compose](https://www.mailofly.com/docs/api/compose).
  ///
  /// **Content** — pick one:
  /// - [templateId]: UUID of a saved template; do not pass [subject] / [body].
  /// - [subject] + [body]: inline HTML message (both required together).
  ///
  /// **Recipients** — pick one:
  /// - [to]: one address, or several separated by comma/space/semicolon.
  /// - [toList]: explicit list of addresses.
  /// - [contactIds]: non-empty list → sends to saved contacts (`recipients.type: contacts`).
  ///
  /// **Merge tags**: pass [variables] for `{{ placeholders }}` in subject/body or template.
  ///
  /// [cc] / [bcc] are included in the JSON if non-empty. The live API may ignore them until
  /// supported server-side; primary recipients are always required via [to], [toList], or [contactIds].
  Future<Map<String, dynamic>> send({
    required String accountKey,
    String? templateId,
    String? subject,
    String? body,
    String? to,
    List<String>? toList,
    List<String>? cc,
    List<String>? bcc,
    List<String>? contactIds,
    Map<String, String>? variables,
  }) async {
    final payload = buildComposeRequestBody(
      accountKey: accountKey,
      templateId: templateId,
      subject: subject,
      body: body,
      to: to,
      toList: toList,
      cc: cc,
      bcc: bcc,
      contactIds: contactIds,
      variables: variables,
    );
    return _asMap(await _t.request('POST', 'compose', body: payload));
  }

  /// Same as [send] but accepts a raw JSON map (escape hatch; matches the REST body exactly).
  Future<Map<String, dynamic>> sendRaw(Map<String, dynamic> body) async =>
      _asMap(await _t.request('POST', 'compose', body: body));
}

class MailoflyMailLogs {
  MailoflyMailLogs(this._t);
  final MailoflyTransport _t;

  Future<Map<String, dynamic>> list({
    int? page,
    int? pageSize,
    String? campaignId,
    String? accountId,
    String? campaignRunId,
    String? status,
  }) async {
    final q = <String, String>{};
    if (page != null) q['page'] = '$page';
    if (pageSize != null) q['page_size'] = '$pageSize';
    if (campaignId != null) q['campaign_id'] = campaignId;
    if (accountId != null) q['account_id'] = accountId;
    if (campaignRunId != null) q['campaign_run_id'] = campaignRunId;
    if (status != null) q['status'] = status;
    return _asMap(await _t.request('GET', 'mail-logs', query: q.isEmpty ? null : q));
  }
}
