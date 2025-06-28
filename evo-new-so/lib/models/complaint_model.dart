import 'models.dart';

part 'complaint_model.g.dart';

@JsonSerializable()
class Complaint {
  final int id;
  @JsonKey(fromJson: _parseTanggal)
  final DateTime? tglInput;
  final String judul;
  final String deskripsi;
  final String img;
  final int st;
  @JsonKey(fromJson: _parseTanggal)
  final DateTime? tglSelesai;
  final String? hasil;
  final int idUser;
  final String namaLengkap;

  Complaint({
    required this.id,
    required this.tglInput,
    required this.judul,
    required this.deskripsi,
    required this.img,
    required this.st,
    required this.tglSelesai,
    required this.hasil,
    required this.idUser,
    required this.namaLengkap,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintToJson(this);

  Complaint copyWith(
      {int? id,
      DateTime? tglInput,
      String? judul,
      String? deskripsi,
      String? img,
      int? st,
      DateTime? tglSelesai,
      String? hasil,
      int? idUser,
      String? namaLengkap}) {
    return Complaint(
      id: id ?? this.id,
      tglInput: tglInput ?? this.tglInput,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      img: img ?? this.img,
      st: st ?? this.st,
      tglSelesai: tglSelesai ?? this.tglSelesai,
      hasil: hasil ?? this.hasil,
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
    );
  }

  static DateTime? _parseTanggal(var tanggal) {
    if (tanggal == null) return null;
    return DateTime.parse(tanggal['date']);
  }

  static List<Complaint> fromJsonList(List jsonList) {
    return jsonList.map((json) => Complaint.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'Complaint(id: $id, tglInput: $tglInput, judul: $judul, deskripsi: $deskripsi, img: $img, st: $st, tglSelesai: $tglSelesai, hasil: $hasil, idUser: $idUser, namaLengkap: $namaLengkap)';
  }
}
