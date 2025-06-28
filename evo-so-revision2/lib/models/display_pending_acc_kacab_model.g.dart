// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_pending_acc_kacab_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayPendingAccKacab _$DisplayPendingAccKacabFromJson(
        Map<String, dynamic> json) =>
    DisplayPendingAccKacab(
      noFaktur: json['No_Faktur'] as String,
      namaCustomer: json['Nama_Customer'] as String,
      lokasi: json['Lokasi'] as String,
      tanggal: DisplayPendingAccKacab._parseTanggal(json['Tanggal']),
      jam: json['Jam'] as String,
      userId: json['UserID'] as String,
      jt: json['JT'] as String,
      selesai: json['Selesai'] as String?,
      status: json['Status'] as String?,
      sudahAccKacab: json['Sudah_Acc_Kacab'] as String?,
      sudahSpcRequest: json['Sudah_Spc_Request'] as String?,
      sudahProses: json['Sudah_Proses'] as String?,
      adaProblem: json['Ada_Problem'] as String?,
      ketProblem: json['Ket_Problem'] as String?,
      sudahSync: json['Sudah_Sync'] as String?,
      flagPlafon: json['Flag_Plafon'] as String?,
      sudahPlafon: json['Sudah_Plafon'] as String?,
      flagLamaJT: json['Flag_Lama_JT'] as String?,
      sudahLamaJT: json['Sudah_Lama_JT'] as String?,
      flagStockKurang: json['Flag_Stock_Kurang'] as String?,
      sudahStockKurang: json['Sudah_Stock_Kurang'] as String?,
    );

Map<String, dynamic> _$DisplayPendingAccKacabToJson(
        DisplayPendingAccKacab instance) =>
    <String, dynamic>{
      'No_Faktur': instance.noFaktur,
      'Nama_Customer': instance.namaCustomer,
      'Lokasi': instance.lokasi,
      'Tanggal': instance.tanggal.toIso8601String(),
      'Jam': instance.jam,
      'UserID': instance.userId,
      'JT': instance.jt,
      'Selesai': instance.selesai,
      'Status': instance.status,
      'Sudah_Acc_Kacab': instance.sudahAccKacab,
      'Sudah_Spc_Request': instance.sudahSpcRequest,
      'Sudah_Proses': instance.sudahProses,
      'Ada_Problem': instance.adaProblem,
      'Ket_Problem': instance.ketProblem,
      'Sudah_Sync': instance.sudahSync,
      'Flag_Plafon': instance.flagPlafon,
      'Sudah_Plafon': instance.sudahPlafon,
      'Flag_Lama_JT': instance.flagLamaJT,
      'Sudah_Lama_JT': instance.sudahLamaJT,
      'Flag_Stock_Kurang': instance.flagStockKurang,
      'Sudah_Stock_Kurang': instance.sudahStockKurang,
    };
