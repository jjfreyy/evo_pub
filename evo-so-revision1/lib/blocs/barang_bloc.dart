part of "bloc_shared.dart";

class BarangCubit extends Cubit<String> {
  BarangCubit(this.kodeKategoriApps) : super("init");

  final String kodeKategoriApps;

  bool fSuccess = true;
  String fTitle = "";
  String fMsg = "";
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  late List<Barang> barangList;
  late TextEditingController tecSearch;
  late List<TextEditingController> tecQtys;

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> _fetchBarang() async {
    if (await isTokenExpired()) return _changeState("tokenExpired");

    final response = await fetchPost("fetch", {
      "type": "barang",
      "kodeKategoriApps": kodeKategoriApps,
      "nama": tecSearch.text,
    });

    if (response.statusCode != 200) throw Exception("Fetch Barang Error!");

    barangList = Barang.fromJsonList(jsonDecode(response.body)["data"]);
    tecQtys.clear();
    barangList.forEach((_) {
      tecQtys.add(TextEditingController());
    });
  }

  Future<void> init() async {
    _changeState("loading");

    try {
      await Future.delayed(Duration(milliseconds: initDelay));
      barangList = [];
      tecSearch = TextEditingController();
      tecQtys = [];
      await _fetchBarang();
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  void resetFlushbar() {
    fTitle = "";
    fMsg = "";
  }

  Future<void> searchBarang() async {
    try {
      timestamp = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(Duration(milliseconds: fetchDelay));
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp - timestamp < fetchDelay) return;

      _changeState("searching");
      await _fetchBarang();
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  Future<void> saveCart(int i) async {
    _changeState("savingToCart");

    if (tecQtys[i].text.isEmpty) {
      fSuccess = false;
      fTitle = barangList[i].namaBarang;
      fMsg = "Qty harus diisi!";
      return _changeState("idle");
    }

    try {
      final response = await fetchPost("put", {
        "type": "kategori",
        "kodeBarang": barangList[i].kodeBarang,
        "qty": tecQtys[i].text,
      });

      if (response.statusCode == 500) throw Exception("Put Barang Error!");

      final json = jsonDecode(response.body);
      fMsg = json["msg"];
      if (response.statusCode != 200) {
        fSuccess = false;
        return _changeState("idle");
      }

      fSuccess = true;
      tecQtys[i].text = "";
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }
}

class Barang {
  final String kodeBarang;
  final String namaBarang;
  final String? image;
  final String satuan;
  final double? stock;
  final int fHrgResellStd;

  Barang(
      {required this.kodeBarang,
      required this.namaBarang,
      required this.image,
      required this.satuan,
      required this.stock,
      required this.fHrgResellStd});

  Barang.fromJson(Map<String, dynamic> json)
      : kodeBarang = json["Kode_Barang"],
        namaBarang = json["Nama"],
        image = json["Image"],
        satuan = json["Satuan"],
        stock = double.tryParse(json["Good_Stock"]),
        fHrgResellStd = json["F_Hrg_Resell_Std"];

  static List<Barang> fromJsonList(List jsonList) {
    return jsonList.map((json) => Barang.fromJson(json)).toList();
  }

  @override
  String toString() {
    return "Barang($kodeBarang, $namaBarang, $image, $satuan, $stock, $fHrgResellStd)";
  }
}
