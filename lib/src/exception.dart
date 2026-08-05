/// Thrown when the API returns a non-success status or the body is not valid JSON.
class MailoflyException implements Exception {
  MailoflyException(
    this.statusCode,
    this.error, [
    this.message,
    this.body,
  ]);

  final int statusCode;
  final String error;
  final String? message;
  final Object? body;

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) {
      return 'MailoflyException($statusCode): $error — $message';
    }
    return 'MailoflyException($statusCode): $error';
  }
}
