class FetchResponse {
  final bool success;
  final String? msg;
  final dynamic value;
  final bool isTokenExpired;

  FetchResponse(
      {required this.success,
      this.msg,
      this.value,
      this.isTokenExpired = false});

  @override
  String toString() {
    return 'FetchResult(\nsuccess: $success\nmsg: $msg\nvalue: $value\n)';
  }
}
