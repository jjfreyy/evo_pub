import 'models.dart';

part 'barang_model.g.dart';

@JsonSerializable()
class Barang {
  @JsonKey(name: 'Kode_Barang')
  final String kode;
  @JsonKey(name: 'Nama')
  final String nama;
  @JsonKey(name: 'Image')
  final String? image;
  @JsonKey(name: 'Satuan')
  final String satuan;
  @JsonKey(name: 'Good_Stock', fromJson: _parseStock)
  final double stock;
  @JsonKey(name: 'F_Hrg_Resell_Std')
  final int fHrgResellStd;

  Barang({
    required this.kode,
    required this.nama,
    required this.image,
    required this.satuan,
    required this.stock,
    required this.fHrgResellStd,
  });

  static double _parseStock(var goodStock) {
    return double.parse(goodStock.toString());
  }

  factory Barang.fromJson(Map<String, dynamic> json) => _$BarangFromJson(json);

  static List<Barang> fromJsonList(List jsonList) {
    return jsonList.map((json) => Barang.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$BarangToJson(this);

  @override
  String toString() {
    return 'Barang($kode, $nama, $image, $satuan, $stock, $fHrgResellStd)';
  }
}
