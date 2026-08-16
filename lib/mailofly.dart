/// Official Dart client for the [Mailofly](https://www.mailofly.com) REST API.
library;

export 'src/client.dart';
export 'src/compose.dart' show buildComposeRequestBody, buildEmailsRequestBody;
export 'src/exception.dart';
export 'src/transport.dart' show kDefaultBaseUrl, normalizeBaseUrl;
