part of "bloc_shared.dart";

class CheckoutCubit extends Cubit<String> {
  CheckoutCubit() : super("init");

  bool fSuccess = true;
  String fMsg = "";

  final jnsTrx = ["Tunai", "Kredit"];
  late List<Checkout> checkoutList;
  late String currentTrx;
  late String masterTrx;

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  void changeTrx(String val) {
    _changeState("changeDropdown");
    currentTrx = val;
    _changeState("idle");
  }

  Future<void> init() async {
    _changeState("loading");

    try {
      if (await isTokenExpired()) return _changeState("tokenExpired");

      await Future.delayed(Duration(milliseconds: initDelay));

      final response = await fetchPost("fetch", {
        "type": "cart",
      });

      if (response.statusCode != 200)
        throw new Exception("Fetch Checkout Error!");

      checkoutList = Checkout.fromJsonList(jsonDecode(response.body)["data"]);
      currentTrx = masterTrx = jnsTransaksiCustomer;
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  void resetFlushbar() {
    fMsg = "";
  }
}

class Checkout {
  final String kodePerusahaan;
  final DateTime tanggal;
  final String userID;
  final String lokasi;
  final String kodeBarang;
  final String namaBarang;
  final String satuan;
  final int qty;
  final String kodePaket;
  final String flagPaket;
  final double harga;
  final String kodeSatuanBesar;
  final double isiSatuanBesar;
  final String kodePaket2;

  Checkout({
    required this.kodePerusahaan,
    required this.tanggal,
    required this.userID,
    required this.lokasi,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.qty,
    required this.kodePaket,
    required this.flagPaket,
    required this.harga,
    required this.kodeSatuanBesar,
    required this.isiSatuanBesar,
    required this.kodePaket2,
  });

  Checkout.fromJson(Map<String, dynamic> json)
      : kodePerusahaan = json["Kode_Perusahaan"],
        tanggal = DateTime.parse(json["Tanggal"]["date"]),
        userID = json["UserID"],
        lokasi = json["Lokasi"],
        kodeBarang = json["Kode_Barang"],
        namaBarang = json["Nama_Barang"],
        satuan = json["Satuan"],
        qty = json["Qty"],
        kodePaket = json["Kode_Paket"],
        flagPaket = json["Flag_Paket"],
        harga = json["Harga"] is int ? json["Harga"].toDouble() : json["Harga"],
        kodeSatuanBesar = json["Kode_Satuan_Besar"],
        isiSatuanBesar = json["Isi_Satuan_Besar"] is int
            ? json["Isi_Satuan_Besar"].toDouble()
            : json["Isi_Satuan_Besar"],
        kodePaket2 = json["Kode_Paket2"].toString().trim();

  static List<Checkout> fromJsonList(List jsonList) {
    return jsonList.map((json) => Checkout.fromJson(json)).toList();
  }

  @override
  String toString() {
    return "Checkout($kodePerusahaan, $tanggal, $userID, $lokasi, $kodeBarang, $namaBarang, $satuan, $qty, $kodePaket, $flagPaket, $harga, $kodeSatuanBesar, $isiSatuanBesar, $kodePaket2)";
  }
}
