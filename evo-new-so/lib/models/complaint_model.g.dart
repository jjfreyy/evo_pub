// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Complaint _$ComplaintFromJson(Map<String, dynamic> json) => Complaint(
      id: json['id'] as int,
      tglInput: Complaint._parseTanggal(json['tglInput']),
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      img: json['img'] as String,
      st: json['st'] as int,
      tglSelesai: Complaint._parseTanggal(json['tglSelesai']),
      hasil: json['hasil'] as String?,
      idUser: json['idUser'] as int,
      namaLengkap: json['namaLengkap'] as String,
    );

Map<String, dynamic> _$ComplaintToJson(Complaint instance) => <String, dynamic>{
      'id': instance.id,
      'tglInput': instance.tglInput?.toIso8601String(),
      'judul': instance.judul,
      'deskripsi': instance.deskripsi,
      'img': instance.img,
      'st': instance.st,
      'tglSelesai': instance.tglSelesai?.toIso8601String(),
      'hasil': instance.hasil,
      'idUser': instance.idUser,
      'namaLengkap': instance.namaLengkap,
    };
