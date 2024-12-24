import 'package:http/http.dart' as http;

class AuthenticatedHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner;

  AuthenticatedHttpClient(this._headers, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
