import 'models.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class Cart {
  @JsonKey(name: 'Kode_Perusahaan')
  final String kodePerusahaan;
  @JsonKey(name: 'Tanggal', fromJson: _parseTanggal)
  final DateTime tanggal;
  @JsonKey(name: 'UserID')
  final String userID;
  @JsonKey(name: 'Lokasi')
  final String lokasi;
  @JsonKey(name: 'Kode_Barang')
  final String kodeBarang;
  @JsonKey(name: 'Nama_Barang')
  final String namaBarang;
  @JsonKey(name: 'Satuan')
  final String satuan;
  @JsonKey(name: 'Disc')
  final int disc;
  @JsonKey(name: 'Qty')
  final int qty;
  @JsonKey(name: 'Kode_Paket')
  final String kodePaket;
  @JsonKey(name: 'Flag_Paket')
  final String flagPaket;
  @JsonKey(name: 'Harga')
  final double harga;
  @JsonKey(name: 'Kode_Satuan_Besar')
  final String kodeSatuanBesar;
  @JsonKey(name: 'Isi_Satuan_Besar')
  final double isiSatuanBesar;
  @JsonKey(name: 'Kode_Paket2')
  final String kodePaket2;

  Cart({
    required this.kodePerusahaan,
    required this.tanggal,
    required this.userID,
    required this.lokasi,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.disc,
    required this.qty,
    required this.kodePaket,
    required this.flagPaket,
    required this.harga,
    required this.kodeSatuanBesar,
    required this.isiSatuanBesar,
    required this.kodePaket2,
  });

  Cart copyWith({
    String? kodePerusahaan,
    DateTime? tanggal,
    String? userID,
    String? lokasi,
    String? kodeBarang,
    String? namaBarang,
    String? satuan,
    int? disc,
    int? qty,
    String? kodePaket,
    String? flagPaket,
    double? harga,
    String? kodeSatuanBesar,
    double? isiSatuanBesar,
    String? kodePaket2,
  }) {
    return Cart(
      kodePerusahaan: kodePerusahaan ?? this.kodePerusahaan,
      tanggal: tanggal ?? this.tanggal,
      userID: userID ?? this.userID,
      lokasi: lokasi ?? this.lokasi,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      satuan: satuan ?? this.satuan,
      disc: disc ?? this.disc,
      qty: qty ?? this.qty,
      kodePaket: kodePaket ?? this.kodePaket,
      flagPaket: flagPaket ?? this.flagPaket,
      harga: harga ?? this.harga,
      kodeSatuanBesar: kodeSatuanBesar ?? this.kodeSatuanBesar,
      isiSatuanBesar: isiSatuanBesar ?? this.isiSatuanBesar,
      kodePaket2: kodePaket2 ?? this.kodePaket2,
    );
  }

  static DateTime _parseTanggal(var tanggal) {
    return DateTime.parse(tanggal['date']);
  }

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  static List<Cart> fromJsonList(List jsonList) {
    return jsonList.map((json) => Cart.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => _$CartToJson(this);

  @override
  String toString() {
    return 'Cart($kodePerusahaan, $tanggal, $userID, $lokasi, $kodeBarang, $namaBarang, $satuan, $disc, $qty, $kodePaket, $flagPaket, $harga, $kodeSatuanBesar, $isiSatuanBesar, $kodePaket2)';
  }
}
