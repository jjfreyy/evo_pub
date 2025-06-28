class FetchResponse {
  final bool success;
  final String? msg;
  final dynamic value;
  final dynamic feedbacks;
  final bool isTokenExpired;

  FetchResponse(
      {required this.success,
      this.msg,
      this.value,
      this.feedbacks,
      this.isTokenExpired = false});

  @override
  String toString() {
    return 'FetchResult(\nsuccess: $success\nmsg: $msg\nvalue: $value\nfeedbacks: $feedbacks\n)';
  }
}
