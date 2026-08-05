/// Builds the JSON body for `POST /api/v1/compose`.
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
  final key = accountKey.trim();
  if (key.isEmpty) {
    throw ArgumentError.value(accountKey, 'accountKey', 'cannot be empty');
  }

  final tid = templateId?.trim();
  final hasTemplate = tid != null && tid.isNotEmpty;
  final sub = subject?.trim() ?? '';
  final html = body?.trim() ?? '';
  final hasInline = sub.isNotEmpty && html.isNotEmpty;

  if (hasTemplate && (sub.isNotEmpty || html.isNotEmpty)) {
    throw ArgumentError(
      'Use templateId or subject+body, not both.',
    );
  }
  if (!hasTemplate && !hasInline) {
    throw ArgumentError(
      'Provide templateId, or both subject and body (HTML).',
    );
  }

  final out = <String, dynamic>{'account_key': key};

  if (hasTemplate) {
    out['template_id'] = tid;
  } else {
    out['subject'] = sub;
    out['body'] = html;
  }

  final ids = contactIds?.map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? [];
  if (ids.isNotEmpty) {
    out['recipients'] = <String, dynamic>{
      'type': 'contacts',
      'contact_ids': ids,
    };
  } else {
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
      throw ArgumentError(
        'Provide to, toList, or contactIds for recipients.',
      );
    }
    out['recipients'] = <String, dynamic>{'emails': emails};
  }

  if (variables != null && variables.isNotEmpty) {
    out['variables'] = variables;
  }

  final ccList = cc?.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  if (ccList != null && ccList.isNotEmpty) {
    out['cc'] = ccList;
  }
  final bccList = bcc?.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  if (bccList != null && bccList.isNotEmpty) {
    out['bcc'] = bccList;
  }

  return out;
}
