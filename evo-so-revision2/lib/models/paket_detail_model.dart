import 'models.dart';

part 'paket_detail_model.g.dart';

@JsonSerializable()
class PaketDetail {
  @JsonKey(name: 'Hrs_Budgeting')
  final String? hrsBudgeting;
  @JsonKey(name: 'X_Hrg_Mid')
  final double xHrgMid;
  @JsonKey(name: 'Kode_SO')
  final String? kodeSO;
  @JsonKey(name: 'Kode_Paket')
  final String? kodePaket;
  @JsonKey(name: 'Pakai_Range')
  final String? pakaiRange;
  @JsonKey(name: 'Diskon_Cash')
  final double diskonCash;
  @JsonKey(name: 'Min_Order')
  final double? minOrder;
  @JsonKey(name: 'pkt2')
  final String? pkt2;
  @JsonKey(name: 'Max_Order')
  final double? maxOrder;
  @JsonKey(name: 'Flag_Satuan_Besar')
  final String? flagSatuanBesar;
  @JsonKey(name: 'Colly1')
  final double? colly1;
  @JsonKey(name: 'Colly2')
  final double? colly2;
  @JsonKey(name: 'Kode_Stock_Owner')
  final String? kodeStockOwner;
  @JsonKey(name: 'Kode_Barang')
  final String? kodeBarang;
  @JsonKey(name: 'Nama')
  final String nama;
  @JsonKey(name: 'Jml')
  final double jml;
  @JsonKey(name: 'Disc_Persen')
  final double discPersen;
  @JsonKey(name: 'Kategori')
  final String? kategori;
  @JsonKey(name: 'Bonus')
  final String? bonus;
  @JsonKey(name: 'Dari')
  final double dari;
  @JsonKey(name: 'Sampai')
  final double sampai;
  @JsonKey(name: 'F_Hrg_Resell_Std')
  final double? fHrgResellStd;
  @JsonKey(name: 'Satuan')
  final String? satuan;
  @JsonKey(name: 'Disc1')
  final double disc1;
  @JsonKey(name: 'Kode_Satuan_Besar')
  final String? kodeSatuanBesar;
  @JsonKey(name: 'Isi_Satuan_Besar')
  final double isiSatuanBesar;

  PaketDetail({
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

  factory PaketDetail.fromJson(Map<String, dynamic> json) =>
      _$PaketDetailFromJson(json);

  static List<PaketDetail> fromJsonList(List jsonList) {
    return jsonList.map((json) => PaketDetail.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$PaketDetailToJson(this);

  @override
  String toString() {
    return 'PaketDetailRange($hrsBudgeting, $xHrgMid, $kodeSO, $kodePaket, $pakaiRange, $diskonCash, $minOrder, $pkt2, $maxOrder, $flagSatuanBesar, $colly1, $colly2, $kodeStockOwner, $kodeBarang, $nama, $jml, $discPersen, $kategori, $bonus, $dari, $sampai, $fHrgResellStd, $satuan, $disc1, $kodeSatuanBesar, $isiSatuanBesar)';
  }
}
