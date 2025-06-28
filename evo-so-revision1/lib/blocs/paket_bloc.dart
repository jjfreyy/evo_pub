part of "bloc_shared.dart";

class PaketCubit extends Cubit<String> {
  PaketCubit() : super("init");

  bool fSuccess = true;
  String fTitle = "";
  String fMsg = "";
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  late List<Paket> paketList;
  late TextEditingController tecSearch;

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> _fetchPaket() async {
    if (await isTokenExpired()) return _changeState("tokenExpired");

    await Future.delayed(Duration(milliseconds: initDelay));
    final response = await fetchPost(
        "fetch", {"type": "paket", "kodePaket": tecSearch.text});

    if (response.statusCode != 200) throw Exception("Fetch Paket Error!");

    paketList = Paket.fromJsonList(jsonDecode(response.body)["data"]);
  }

  Future<void> init() async {
    _changeState("loading");

    try {
      await Future.delayed(Duration(milliseconds: initDelay));
      paketList = [];
      tecSearch = TextEditingController();

      await _fetchPaket();
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  Future<void> searchPaket() async {
    try {
      timestamp = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(Duration(milliseconds: fetchDelay));
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp - timestamp < fetchDelay) return;

      _changeState("searching");
      await _fetchPaket();
    } catch (_) {
      if (debug) dd(_);
      fSuccess = false;
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }
}

class Paket {
  final String kodeSO;
  final String kodePaket;
  final String? pakaiRange;
  final double diskonCash;
  final double? minOrder;
  final String? pkt2;
  final double? maxOrder;
  final String? flagSatuanBesar;
  final double? colly1;
  final double? colly2;
  final String? hrsBudgeting;

  Paket(
      {required this.kodeSO,
      required this.kodePaket,
      required this.pakaiRange,
      required this.diskonCash,
      required this.minOrder,
      required this.pkt2,
      required this.maxOrder,
      required this.flagSatuanBesar,
      required this.colly1,
      required this.colly2,
      required this.hrsBudgeting});

  Paket.fromJson(Map<String, dynamic> json)
      : kodeSO = json["Kode_SO"],
        kodePaket = json["Kode_Paket"],
        pakaiRange = json["Pakai_Range"],
        diskonCash = json["Diskon_Cash"] is int
            ? json["Diskon_Cash"].toDouble()
            : json["Diskon_Cash"],
        minOrder = json["Min_Order"] is int
            ? json["Min_Order"].toDouble()
            : json["Min_Order"],
        pkt2 = json["Pkt_2"],
        maxOrder = json["Max_Order"] is int
            ? json["Max_Order"].toDouble()
            : json["Max_Order"],
        flagSatuanBesar = json["Flag_Satuan_Besar"],
        colly1 =
            json["Colly1"] is int ? json["Colly1"].toDouble() : json["Colly1"],
        colly2 =
            json["Colly2"] is int ? json["Colly2"].toDouble() : json["Colly2"],
        hrsBudgeting = json["Hrs_Budgeting"];

  static List<Paket> fromJsonList(List jsonList) {
    return jsonList.map((json) => Paket.fromJson(json)).toList();
  }

  @override
  String toString() {
    return "Paket($kodeSO, $kodePaket, $pakaiRange, $diskonCash, $minOrder, $pkt2, $maxOrder, $flagSatuanBesar, $colly1, $colly2, $hrsBudgeting)";
  }
}
