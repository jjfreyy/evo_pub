import 'models.dart';

part 'display_pending_acc_kacab_model.g.dart';

@JsonSerializable()
class DisplayPendingAccKacab {
  @JsonKey(name: 'No_Faktur')
  final String noFaktur;
  @JsonKey(name: 'Nama_Customer')
  final String namaCustomer;
  @JsonKey(name: 'Lokasi')
  final String lokasi;
  @JsonKey(name: 'Tanggal', fromJson: _parseTanggal)
  final DateTime tanggal;
  @JsonKey(name: 'Jam')
  final String jam;
  @JsonKey(name: 'UserID')
  final String userId;
  @JsonKey(name: 'JT')
  final String jt;
  @JsonKey(name: 'Selesai')
  final String? selesai;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'Sudah_Acc_Kacab')
  final String? sudahAccKacab;
  @JsonKey(name: 'Sudah_Spc_Request')
  final String? sudahSpcRequest;
  @JsonKey(name: 'Sudah_Proses')
  final String? sudahProses;
  @JsonKey(name: 'Ada_Problem')
  final String? adaProblem;
  @JsonKey(name: 'Ket_Problem')
  final String? ketProblem;
  @JsonKey(name: 'Sudah_Sync')
  final String? sudahSync;
  @JsonKey(name: 'Flag_Plafon')
  final String? flagPlafon;
  @JsonKey(name: 'Sudah_Plafon')
  final String? sudahPlafon;
  @JsonKey(name: 'Flag_Lama_JT')
  final String? flagLamaJT;
  @JsonKey(name: 'Sudah_Lama_JT')
  final String? sudahLamaJT;
  @JsonKey(name: 'Flag_Stock_Kurang')
  final String? flagStockKurang;
  @JsonKey(name: 'Sudah_Stock_Kurang')
  final String? sudahStockKurang;

  DisplayPendingAccKacab({
    required this.noFaktur,
    required this.namaCustomer,
    required this.lokasi,
    required this.tanggal,
    required this.jam,
    required this.userId,
    required this.jt,
    required this.selesai,
    required this.status,
    required this.sudahAccKacab,
    required this.sudahSpcRequest,
    required this.sudahProses,
    required this.adaProblem,
    required this.ketProblem,
    required this.sudahSync,
    required this.flagPlafon,
    required this.sudahPlafon,
    required this.flagLamaJT,
    required this.sudahLamaJT,
    required this.flagStockKurang,
    required this.sudahStockKurang,
  });

  factory DisplayPendingAccKacab.fromJson(Map<String, dynamic> json) =>
      _$DisplayPendingAccKacabFromJson(json);

  static List<DisplayPendingAccKacab> fromJsonList(List jsonList) {
    return jsonList
        .map((json) => DisplayPendingAccKacab.fromJson(json))
        .toList();
  }

  static DateTime _parseTanggal(var tanggal) {
    return DateTime.parse(tanggal['date']);
  }

  Map<String, dynamic> toJson() => _$DisplayPendingAccKacabToJson(this);

  @override
  String toString() {
    return 'DisplayPendingAccKacab($noFaktur, $namaCustomer, $lokasi, $tanggal, $jam, $userId, $jt, $selesai, $status, $sudahAccKacab, $sudahSpcRequest, $sudahProses, $adaProblem, $ketProblem, $sudahSync, $flagPlafon, $sudahPlafon, $flagLamaJT, $sudahLamaJT, $flagStockKurang, $sudahStockKurang)';
  }
}
