/// Builds the JSON body for `POST /emails` (Resend-compatible).
Map<String, dynamic> buildEmailsRequestBody({
  required String from,
  required Object to,
  String? subject,
  String? html,
  String? text,
  String? accountKey,
  Object? cc,
  Object? bcc,
  Object? replyTo,
  Map<String, String>? headers,
  List<Map<String, String>>? tags,
  List<Map<String, dynamic>>? attachments,
  Map<String, dynamic>? template,
}) {
  final fromAddr = from.trim();
  if (fromAddr.isEmpty) {
    throw ArgumentError.value(from, 'from', 'cannot be empty');
  }
  return {
    'from': fromAddr,
    'to': to,
    if (subject != null) 'subject': subject,
    if (html != null) 'html': html,
    if (text != null) 'text': text,
    if (accountKey != null && accountKey.trim().isNotEmpty) 'account_key': accountKey.trim(),
    if (cc != null) 'cc': cc,
    if (bcc != null) 'bcc': bcc,
    if (replyTo != null) 'reply_to': replyTo,
    if (headers != null) 'headers': headers,
    if (tags != null) 'tags': tags,
    if (attachments != null) 'attachments': attachments,
    if (template != null) 'template': template,
  };
}

/// @deprecated Use [buildEmailsRequestBody] instead.
@Deprecated('Use buildEmailsRequestBody for POST /emails')
Map<String, dynamic> buildComposeRequestBody({
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
}) {
  if (contactIds != null && contactIds.isNotEmpty) {
    throw ArgumentError('contactIds are not supported on POST /emails');
  }

  final seen = <String>{};
  final emails = <String>[];
  void addEmail(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return;
    final k = s.toLowerCase();
    if (seen.contains(k)) return;
    seen.add(k);
    emails.add(s);
  }
  if (toList != null) {
    for (final e in toList) {
      addEmail(e);
    }
  }
  if (to != null && to.trim().isNotEmpty) {
    for (final e in to.split(RegExp(r'[\s,;]+'))) {
      addEmail(e);
    }
  }
  if (emails.isEmpty) {
    throw ArgumentError('Provide to or toList for recipients.');
  }

  final tid = templateId?.trim();
  final hasTemplate = tid != null && tid.isNotEmpty;

  return buildEmailsRequestBody(
    from: 'onboarding@example.com',
    to: emails.length == 1 ? emails.first : emails,
    accountKey: accountKey,
    subject: hasTemplate ? null : subject,
    html: hasTemplate ? null : body,
    cc: cc,
    bcc: bcc,
    template: hasTemplate
        ? {
            'id': tid,
            if (variables != null && variables.isNotEmpty) 'variables': variables,
          }
        : null,
  );
}
