/// Builds the JSON body for `POST /api/v1/emails` (Resend-compatible).
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

  final out = <String, dynamic>{
    'from': fromAddr,
    'to': to,
  };

  final key = accountKey?.trim();
  if (key != null && key.isNotEmpty) out['account_key'] = key;

  final sub = subject?.trim();
  if (sub != null && sub.isNotEmpty) out['subject'] = sub;

  final htmlBody = html?.trim();
  if (htmlBody != null && htmlBody.isNotEmpty) out['html'] = htmlBody;

  final textBody = text?.trim();
  if (textBody != null && textBody.isNotEmpty) out['text'] = textBody;

  if (template != null && template.isNotEmpty) out['template'] = template;
  if (cc != null) out['cc'] = cc;
  if (bcc != null) out['bcc'] = bcc;
  if (replyTo != null) out['reply_to'] = replyTo;
  if (headers != null && headers.isNotEmpty) out['headers'] = headers;
  if (tags != null && tags.isNotEmpty) out['tags'] = tags;
  if (attachments != null && attachments.isNotEmpty) out['attachments'] = attachments;

  return out;
}

/// @deprecated Use [buildEmailsRequestBody] instead.
@Deprecated('Use buildEmailsRequestBody for POST /api/v1/emails')
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
    throw ArgumentError('contactIds are not supported on POST /v1/emails');
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
    for (final e in toList) addEmail(e);
  }
  if (to != null && to.trim().isNotEmpty) {
    for (final e in to.split(RegExp(r'[\s,;]+'))) addEmail(e);
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
