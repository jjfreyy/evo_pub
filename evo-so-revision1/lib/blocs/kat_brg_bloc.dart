part of "bloc_shared.dart";

class KatBrgCubit extends Cubit<String> {
  KatBrgCubit() : super("init");

  String fMsg = "";

  List<KatBrg> katBrgList = [];

  void _changeState(String newState) {
    if (!isClosed) emit(newState);
  }

  Future<void> init() async {
    _changeState("loading");

    try {
      await Future.delayed(Duration(milliseconds: initDelay));

      if (await isTokenExpired()) return emit("tokenExpired");

      final response = await fetchPost(
        "fetch",
        {"type": "kategori_barang"},
      );

      if (response.statusCode != 200) throw Exception("KatBrg Error!");

      katBrgList = KatBrg.fromJsonList(jsonDecode(response.body)["data"]);
    } catch (_) {
      if (debug) dd(_);
      fMsg = getInternalServerMsg();
    }

    _changeState("idle");
  }

  void resetFlushbar() {
    fMsg = "";
  }
}

class KatBrg {
  final String nama;
  final dynamic image;

  KatBrg(this.nama, this.image);

  KatBrg.fromJson(Map<String, dynamic> json)
      : nama = json["Nama"],
        image = json["Image"];

  static List<KatBrg> fromJsonList(List jsonList) {
    return jsonList.map((json) => KatBrg.fromJson(json)).toList();
  }

  @override
  String toString() {
    return "KatBrg($nama, $image)";
  }
}
