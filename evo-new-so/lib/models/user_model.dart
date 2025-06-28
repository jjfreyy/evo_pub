import 'models.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String namaLengkap;
  final String username;
  final int userLevel;
  final int? idCabang;
  final String? cabang;
  final int? idLokasi;
  final String? lokasi;

  User({
    required this.id,
    required this.namaLengkap,
    required this.username,
    required this.userLevel,
    required this.idCabang,
    required this.cabang,
    required this.idLokasi,
    required this.lokasi,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User(id: $id, namaLengkap: $namaLengkap, username: $username, userLevel: $userLevel, idCabang: $idCabang, cabang: $cabang, idLokasi: $idLokasi, lokasi: $lokasi)';
  }
}
