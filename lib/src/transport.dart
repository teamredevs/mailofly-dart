import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exception.dart';

const String kDefaultBaseUrl = 'https://www.mailofly.com';

String normalizeBaseUrl(String url) => url.replaceAll(RegExp(r'/+$'), '');

/// Low-level HTTP for Mailofly `/api/v1`.
class MailoflyTransport {
  MailoflyTransport({
    required this.baseUrl,
    required this.apiKey,
    http.Client? client,
  })  : _ownsClient = client == null,
        _client = client ?? http.Client();

  final String baseUrl;
  final String apiKey;
  final http.Client _client;
  final bool _ownsClient;

  Uri _uri(String path, Map<String, String>? query) {
    final suffix = path.startsWith('/') ? path.substring(1) : path;
    final absPath = suffix.isEmpty ? '/api/v1' : '/api/v1/$suffix';
    var u = Uri.parse(baseUrl).resolve(absPath);
    if (query != null && query.isNotEmpty) {
      u = u.replace(queryParameters: query);
    }
    return u;
  }

  /// [path] is relative to `/api/v1` (e.g. `accounts` or `accounts/uuid`). Use `''` for discovery.
  Future<Object?> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool withAuth = true,
  }) async {
    final uri = _uri(path, query);
    final headers = <String, String>{
      'Accept': 'application/json',
      'X-Mailofly-Client': 'sdk/dart',
    };
    if (withAuth) {
      if (apiKey.isEmpty) {
        throw ArgumentError('Mailofly apiKey is required for authenticated requests');
      }
      headers['Authorization'] = 'Bearer $apiKey';
    }
    String? encodedBody;
    if (body != null) {
      headers['Content-Type'] = 'application/json';
      encodedBody = jsonEncode(body);
    }

    late http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
      case 'POST':
        response = await _client.post(uri, headers: headers, body: encodedBody);
      case 'PATCH':
        response = await _client.patch(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        response = await _client.delete(uri, headers: headers, body: encodedBody);
      default:
        throw ArgumentError('Unsupported method: $method');
    }

    final text = response.body;
    Object? parsed;
    if (text.isNotEmpty) {
      try {
        parsed = jsonDecode(text) as Object?;
      } catch (_) {
        parsed = text;
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String err = response.reasonPhrase ?? 'HTTP ${response.statusCode}';
      String? msg;
      if (parsed is Map<String, dynamic>) {
        err = parsed['error']?.toString() ?? err;
        msg = parsed['message']?.toString();
      } else if (parsed is Map) {
        final m = Map<String, dynamic>.from(parsed);
        err = m['error']?.toString() ?? err;
        msg = m['message']?.toString();
      }
      throw MailoflyException(response.statusCode, err, msg, parsed);
    }

    return parsed;
  }

  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
