import 'models.dart';

part 'paket_model.g.dart';

@JsonSerializable()
class Paket {
  @JsonKey(name: 'Kode_SO')
  final String kodeSO;
  @JsonKey(name: 'Kode_Paket')
  final String kodePaket;
  @JsonKey(name: 'Pakai_Range')
  final String? pakaiRange;
  @JsonKey(name: 'Diskon_Cash')
  final double diskonCash;
  @JsonKey(name: 'Min_Order')
  final double? minOrder;
  @JsonKey(name: 'Pkt_2')
  final String? pkt2;
  @JsonKey(name: 'Max_Order')
  final double? maxOrder;
  @JsonKey(name: 'Flag_Satuan_Besar')
  final String? flagSatuanBesar;
  @JsonKey(name: 'Colly1')
  final double? colly1;
  @JsonKey(name: 'Colly2')
  final double? colly2;
  @JsonKey(name: 'Hrs_Budgeting')
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

  factory Paket.fromJson(Map<String, dynamic> json) => _$PaketFromJson(json);

  static List<Paket> fromJsonList(List jsonList) {
    return jsonList.map((json) => Paket.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$PaketToJson(this);

  @override
  String toString() {
    return 'Paket($kodeSO, $kodePaket, $pakaiRange, $diskonCash, $minOrder, $pkt2, $maxOrder, $flagSatuanBesar, $colly1, $colly2, $hrsBudgeting)';
  }
}

