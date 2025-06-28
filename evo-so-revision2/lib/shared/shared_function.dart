part of 'shared.dart';

String formatInteger(int _nilai, BuildContext context) {
  String hasil;

  hasil = NumberFormat.currency(
    locale: 'en',
    symbol: '',
    decimalDigits: 0,
  ).format(_nilai);

  return hasil;
}

String formatDouble(double _nilai, int _desimal, BuildContext context) {
  String hasil;

  hasil = NumberFormat.currency(
    locale: 'en',
    symbol: '',
    decimalDigits: _desimal,
  ).format(_nilai);

  return hasil;
}

String convertKeSatuanBesar(
    String _satuanBesar, double _isiBesar, String _satuanKecil, double _jml) {
  String hasil;
  String hasil2;
  double nilai = 0;

  if (_isiBesar == 1) {
    hasil = '';
  } else {
    nilai = _jml / _isiBesar;

    if (nilai.floor() == 0) {
      hasil = '';
    } else {
      hasil = nilai.floor().toString() + ' ' + _satuanBesar;
    }
  }

  if (_isiBesar == 1) {
    hasil2 = _jml.toString() + ' ' + _satuanKecil;
  } else {
    //double nilai = _jml / _isiBesar;
    double nilai2;

    nilai2 = _jml - (nilai.floor() * _isiBesar);

    if (nilai2 == 0) {
      hasil2 = '';
    } else {
      hasil2 = nilai2.floor().toString() + ' ' + _satuanKecil;
    }
  }

  if (nilai.floor() == 0) {
    return '';
  } else {
    return hasil + '   ' + hasil2;
  }
}

double hitungSubtotalPerBarang(
    double _discPersen, double _discRP, double _jml, double _hrg) {
  double total;

  if (_discPersen > 0) {
    total = (_hrg * _jml) - (_hrg * _jml * _discPersen / 100);
  } else {
    total = (_hrg - _discPersen) * _jml;
  }

  return total;
}

void refreshKodeUnik() {
  var randomGenerator = Random();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kkmmssd').format(now);

  kodeUnik = 'SO' +
      formattedDate +
      randomGenerator.nextInt(10000).toString() +
      randomGenerator.nextInt(10000).toString();
}

void refreshChekcout() {
  kodeCust = '';
  namaCust = '';
  jnsTransaksiCustomer = '';

  refreshKodeUnik();
}

// function tambahan
String apiUrl([String url = '']) {
  // return 'http://hendryanto.xyz/testing/evo-api/$url';
  // return 'http://172.20.10.4/evo-api/$url';
  // return 'http://192.168.0.188/evo-api/$url';
  return 'http://192.168.1.200/evo-api/$url';
}

void clearSharedPreferences() {
  getSharedPreferences().then((prefs) => prefs.clear());
}

void dd(dynamic val) {
  final dateFormatter = DateFormat('MMM d, yyyy HH:mm:ss');
  final formattedDate = dateFormatter.format(DateTime.now());
  debugPrint('${repeat()} $formattedDate\n$val\n${repeat(137)}');
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
    {bool withToken = true, returnDataOnly = true, debug = false}) async {
  try {
    if (withToken && (await isTokenExpired())) {
      return FetchResponse(
          success: false, msg: 'Expired Token!', isTokenExpired: true);
    }

    final response = await fetchPost(url, data, withToken);
    if (response.statusCode == 500) throw Exception([apiUrl(url), data]);

    final jsonBody = jsonDecode(response.body);
    if (debug) dd(jsonBody);
    final msg = jsonBody['msg'];
    if (response.statusCode != 200) {
      return FetchResponse(
        success: false,
        msg: msg ?? getInternalServerMsg(),
      );
    }

    var result = jsonBody;
    if (returnDataOnly && !isEmpty(jsonBody['data'])) result = jsonBody['data'];
    return FetchResponse(
        success: true, msg: msg ?? 'Request Successfull!', value: result);
  } catch (_) {
    dd('fetchPost2: ${_.toString()}');
    return FetchResponse(success: false, msg: getInternalServerMsg());
  }
}

String getInternalServerMsg() {
  return 'Terjadi kesalahan internal server.';
}

NumberFormat getNumberFormat() {
  return NumberFormat.currency(locale: 'en', symbol: '', decimalDigits: 0);
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

String repeat([int count = 115, String char = '-']) {
  return char * count;
}

String socketUrl() {
  // return 'http://172.20.10.4:3000';
  // return 'http://192.168.0.188:3000';
  return 'http://192.168.1.200:3000';
}
