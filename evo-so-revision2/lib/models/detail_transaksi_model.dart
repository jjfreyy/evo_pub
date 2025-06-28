import 'models.dart';

part 'detail_transaksi_model.g.dart';

@JsonSerializable()
class DetailTransaksi {
  @JsonKey(name: 'Disc_Prsn')
  final int discPersen;
  @JsonKey(name: 'Jumlah', fromJson: _parseJumlah)
  final double jumlah;
  @JsonKey(name: 'Harga')
  final int harga;
  @JsonKey(name: 'Nama_Barang')
  final String namaBarang;
  @JsonKey(name: 'Kode_Pkt')
  final String kodePaket;
  @JsonKey(name: 'Satuan')
  final String satuan;
  @JsonKey(name: 'Kode_Satuan_Besar')
  final String kodeSatuanBesar;
  @JsonKey(name: 'Isi_Satuan_Besar')
  final int isiSatuanBesar;

  DetailTransaksi({
    required this.discPersen,
    required this.jumlah,
    required this.harga,
    required this.namaBarang,
    required this.kodePaket,
    required this.satuan,
    required this.kodeSatuanBesar,
    required this.isiSatuanBesar,
  });

  static double _parseJumlah(var goodStock) {
    return double.parse(goodStock.toString());
  }

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) =>
      _$DetailTransaksiFromJson(json);

  static List<DetailTransaksi> fromJsonList(List jsonList) {
    return jsonList.map((json) => DetailTransaksi.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$DetailTransaksiToJson(this);

  @override
  String toString() {
    return 'DetailTransaksi($discPersen, $jumlah, $harga, $namaBarang, $kodePaket, $satuan, $kodeSatuanBesar, $isiSatuanBesar)';
  }
}
