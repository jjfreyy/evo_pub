part of "bloc_shared.dart";

class PaketDetailRangeCubit extends Cubit<String> {
  PaketDetailRangeCubit(this.kodePaket) : super("init");

  final String kodePaket;

  bool fSuccess = true;
  String fTitle = "";
  String fMsg = "";

  late List<PaketDetailRange> paketDetailRangeList;
  late List<TextEditingController> tecQtys;

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> init() async {
    _changeState("loading");
    
    try {
      if (await isTokenExpired()) return _changeState("tokenExpired");

      await Future.delayed(Duration(milliseconds: initDelay));
      final response = await fetchPost("fetch", {
        "type": "detail_paket",
        "kodePaket": kodePaket,
      });

      if (response.statusCode != 200)
        throw new Exception("Fetch Paket Detail Range Error!");

      paketDetailRangeList =
          PaketDetailRange.fromJsonList(jsonDecode(response.body)["data"]);
      tecQtys = [];
      paketDetailRangeList.forEach((_) {
        tecQtys.add(TextEditingController());
      });
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

  Future<void> saveCart() async {
    _changeState("savingToCart");

    try {
      List paketan = [];
      final dari = paketDetailRangeList[0].dari;
      final sampai = paketDetailRangeList[0].sampai;
      int total = 0;
      for (int i = 0; i < paketDetailRangeList.length; i++) {
        if (tecQtys[i].text.isEmpty) continue;

        final qty = int.parse(tecQtys[i].text);
        total += qty;

        paketan.add({
          "kodeBarang": paketDetailRangeList[i].kodeBarang,
          "jumlah": qty,
          "kodePaket": paketDetailRangeList[i].kodePaket,
          "disc": paketDetailRangeList[i].discPersen,
          "pkt2": paketDetailRangeList[i].pkt2,
          "bonus": paketDetailRangeList[i].bonus,
        });
      }

      if (paketan.length == 0) {
        fSuccess = false;
        fMsg = "Silakan isi data paketan yang ingin ditambah minimal 1.";
        return _changeState("idle");
      }

      if (total < dari || total > sampai) {
        fSuccess = false;
        fMsg =
            "Total paketan harus diantara ${getNumberFormat().format(dari)} dan ${getNumberFormat().format(sampai)}!";
        return _changeState("idle");
      }

      final response = await fetchPost("put", {
        "type": "paket",
        "paketan": jsonEncode(paketan),
      });

      if (response.statusCode == 500)
        throw Exception("Put Paket Detail Range Error!");

      final json = jsonDecode(response.body);
      fMsg = json["msg"];
      if (response.statusCode != 200) {
        fSuccess = false;
        return _changeState("idle");
      }

      fSuccess = true;
      tecQtys.forEach((tec) {
        tec.clear();
      });
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }
}

class PaketDetailRange {
  final String? hrsBudgeting;
  final double xHrgMid;
  final String? kodeSO;
  final String? kodePaket;
  final String? pakaiRange;
  final double diskonCash;
  final double? minOrder;
  final String? pkt2;
  final double? maxOrder;
  final String? flagSatuanBesar;
  final double? colly1;
  final double? colly2;
  final String? kodeStockOwner;
  final String? kodeBarang;
  final String nama;
  final double jml;
  final double discPersen;
  final String? kategori;
  final String? bonus;
  final double dari;
  final double sampai;
  final double? fHrgResellStd;
  final String? satuan;
  final double disc1;
  final String? kodeSatuanBesar;
  final double isiSatuanBesar;

  PaketDetailRange({
    required this.hrsBudgeting,
    required this.xHrgMid,
    required this.kodeSO,
    required this.kodePaket,
    required this.pakaiRange,
    required this.diskonCash,
    required this.minOrder,
    required this.pkt2,
    required this.maxOrder,
    required this.flagSatuanBesar,
    required this.colly1,
    required this.colly2,
    required this.kodeStockOwner,
    required this.kodeBarang,
    required this.nama,
    required this.jml,
    required this.discPersen,
    required this.kategori,
    required this.bonus,
    required this.dari,
    required this.sampai,
    required this.fHrgResellStd,
    required this.satuan,
    required this.disc1,
    required this.kodeSatuanBesar,
    required this.isiSatuanBesar,
  });

  PaketDetailRange.fromJson(Map<String, dynamic> json)
      : hrsBudgeting = json["Hrs_Budgeting"],
        xHrgMid = json["X_Hrg_Mid"] is int
            ? json["X_Hrg_Mid"].toDouble()
            : json["X_Hrg_Mid"],
        kodeSO = json["Kode_SO"],
        kodePaket = json["Kode_Paket"],
        pakaiRange = json["Pakai_Range"],
        diskonCash = json["Diskon_Cash"] is int
            ? json["Diskon_Cash"].toDouble()
            : json["Diskon_Cash"],
        minOrder = json["Min_Order"] is int
            ? json["Min_Order"].toDouble()
            : json["Min_Order"],
        pkt2 = json["pkt2"],
        maxOrder = json["Max_Order"] is int
            ? json["Max_Order"].toDouble()
            : json["Max_Order"],
        flagSatuanBesar = json["Flag_Satuan_Besar"],
        colly1 =
            json["Colly1"] is int ? json["Colly1"].toDouble() : json["Colly1"],
        colly2 =
            json["Colly2"] is int ? json["Colly2"].toDouble() : json["Colly2"],
        kodeStockOwner = json["Kode_StockOwner"],
        kodeBarang = json["Kode_Barang"],
        nama = json["Nama"],
        jml = json["Jml"] is int ? json["Jml"].toDouble() : json["Jml"],
        discPersen = json["Disc_Persen"] is int
            ? json["Disc_Persen"].toDouble()
            : json["Disc_Persen"],
        kategori = json["Kategori"],
        bonus = json["Bonus"],
        dari = json["Dari"] is int ? json["Dari"].toDouble() : json["Dari"],
        sampai =
            json["Sampai"] is int ? json["Sampai"].toDouble() : json["Sampai"],
        fHrgResellStd = json["F_Hrg_Resell_Std"] is int
            ? json["F_Hrg_Resell_Std"].toDouble()
            : json["F_Hrg_Resell_Std"],
        satuan = json["Satuan"],
        disc1 = json["Disc1"] is int ? json["Disc1"].toDouble() : json["Disc1"],
        kodeSatuanBesar = json["Kode_Satuan_Besar"],
        isiSatuanBesar = json["Isi_Satuan_Besar"] is int
            ? json["Isi_Satuan_Besar"].toDouble()
            : json["Isi_Satuan_Besar"];

  static List<PaketDetailRange> fromJsonList(List jsonList) {
    return jsonList.map((json) => PaketDetailRange.fromJson(json)).toList();
  }

  @override
  String toString() {
    return "PaketDetailRange($hrsBudgeting, $xHrgMid, $kodeSO, $kodePaket, $pakaiRange, $diskonCash, $minOrder, $pkt2, $maxOrder, $flagSatuanBesar, $colly1, $colly2, $kodeStockOwner, $kodeBarang, $nama, $jml, $discPersen, $kategori, $bonus, $dari, $sampai, $fHrgResellStd, $satuan, $disc1, $kodeSatuanBesar, $isiSatuanBesar)";
  }
}
