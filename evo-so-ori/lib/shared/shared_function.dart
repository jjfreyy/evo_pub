part of 'shared.dart';

String formatInteger(int _nilai, BuildContext context) {
  String hasil;

  hasil = NumberFormat.currency(
    locale: "en",
    symbol: "",
    decimalDigits: 0,
  ).format(_nilai);

  return hasil;
}

String formatDouble(double _nilai, int _desimal, BuildContext context) {
  String hasil;
  
  hasil = NumberFormat.currency(
    locale: "en",
    symbol: "",
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
    hasil = "";
  } else {
    nilai = _jml / _isiBesar;

    if (nilai.floor() == 0) {
      hasil = "";
    } else {
      hasil = nilai.floor().toString() + " " + _satuanBesar;
    }
  }

  if (_isiBesar == 1) {
    hasil2 = _jml.toString() + " " + _satuanKecil;
  } else {
    //double nilai = _jml / _isiBesar;
    double nilai2;

    nilai2 = _jml - (nilai.floor() * _isiBesar);

    if (nilai2 == 0) {
      hasil2 = "";
    } else {
      hasil2 = nilai2.floor().toString() + " " + _satuanKecil;
    }
  }

  if (nilai.floor() == 0) {
    return "";
  } else {
    return hasil + "   " + hasil2;
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

  kodeUnik = "SO" +
      formattedDate +
      randomGenerator.nextInt(10000).toString() +
      randomGenerator.nextInt(10000).toString();
}

void refreshChekcout() {
  kodeCust = "";
  namaCust = "";
  jnsTransaksiCustomer = "";

  refreshKodeUnik();
}
