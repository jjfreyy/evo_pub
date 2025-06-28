// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      namaLengkap: json['namaLengkap'] as String,
      username: json['username'] as String,
      userLevel: json['userLevel'] as int,
      idCabang: json['idCabang'] as int?,
      cabang: json['cabang'] as String?,
      idLokasi: json['idLokasi'] as int?,
      lokasi: json['lokasi'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'namaLengkap': instance.namaLengkap,
      'username': instance.username,
      'userLevel': instance.userLevel,
      'idCabang': instance.idCabang,
      'cabang': instance.cabang,
      'idLokasi': instance.idLokasi,
      'lokasi': instance.lokasi,
    };
