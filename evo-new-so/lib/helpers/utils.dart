part of 'helpers.dart';

String apiUrl([String url = '']) {
  return 'https://ss-api.evnbdev.com/$url';
  // return 'http://192.168.0.132/evo-ss-api/$url';
}

void dd(dynamic val) {
  final dateFormatter = DateFormat('MMM d, yyyy HH:mm:ss');
  final formattedDate = dateFormatter.format(DateTime.now());
  log('${repeat()} $formattedDate\n$val\n${repeat(137)}');
}

Future<http.Response> fetchPost(String url, Map data,
    [bool withToken = true]) async {
  String body = '';
  int i = 0;
  data.forEach((k, v) {
    if (i > 0) body += '&';
    body += '$k=$v';
    i++;
  });

  Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  if (withToken) {
    final prefs = await getSharedPreferences();
    headers['Authorization'] = prefs.getString('token') ?? '';
  }

  final response = await http
      .post(
        Uri.parse(apiUrl(url)),
        headers: headers,
        body: body,
      )
      .timeout(const Duration(seconds: 120));

  return response;
}

Future<FetchResponse> fetchPost2(String url, Map data,
    {bool withToken = true, returnDataOnly = true, debugging = false}) async {
  try {
    if (withToken && (await isTokenExpired())) {
      return FetchResponse(
          success: false, msg: 'Expired Token!', isTokenExpired: true);
    }

    final response = await fetchPost(url, data, withToken);
    if (response.statusCode == 500) throw Exception([apiUrl(url), data]);

    final jsonBody = jsonDecode(response.body);
    if (debugging) {
      dd('${apiUrl(url)}\ndata: $data\nstatusCode: ${response.statusCode}\nbody: $jsonBody');
    }
    final msg = jsonBody['msg'];
    if (response.statusCode != 200) {
      return FetchResponse(
        success: false,
        msg: msg ?? serverErrorMsg,
        feedbacks: jsonBody['feedbacks'],
      );
    }

    var result = jsonBody;
    if (returnDataOnly && !isEmpty(jsonBody['data'])) result = jsonBody['data'];
    return FetchResponse(
        success: true, msg: msg ?? 'Request Successfull!', value: result);
  } catch (_) {
    if (debug) dd('fetchPost2: ${_.toString()}');
    return FetchResponse(success: false, msg: serverErrorMsg);
  }
}

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.version}+${packageInfo.buildNumber}';
}

NumberFormat getNumberFormat() {
  return NumberFormat.currency(locale: 'en', symbol: '', decimalDigits: 0);
}

Size getScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

Future<SharedPreferences> getSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

String ifEmptyThen(dynamic value, {allowZero = true, assign = '-'}) {
  return isEmpty(value, allowZero) ? assign : value;
}

bool isEmpty(dynamic value, [bool allowZero = true]) {
  if (value == null) return true;
  if (!allowZero && (value.toString() == '0' || value.toString() == '0.0')) {
    return true;
  }

  return value.toString().isEmpty;
}

bool isEmptyArray(dynamic list) {
  if (list == null) return true;
  return list.isEmpty;
}

Future<bool> isTokenExpired() async {
  final prefs = await getSharedPreferences();
  final token = prefs.getString('token');
  return isEmpty(token) || Jwt.isExpired(token as String);
}

void navigateTo(context, Widget widget, [bool pushReplacement = false]) {
  if (!pushReplacement) {
    Navigator.push(context, MaterialPageRoute(builder: ((context) => widget)));
    return;
  }
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: ((context) => widget)));
}

String repeat([int count = 115, String char = '-']) {
  return char * count;
}
