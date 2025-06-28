// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paket _$PaketFromJson(Map<String, dynamic> json) => Paket(
      kodeSO: json['Kode_SO'] as String,
      kodePaket: json['Kode_Paket'] as String,
      pakaiRange: json['Pakai_Range'] as String?,
      diskonCash: (json['Diskon_Cash'] as num).toDouble(),
      minOrder: (json['Min_Order'] as num?)?.toDouble(),
      pkt2: json['Pkt_2'] as String?,
      maxOrder: (json['Max_Order'] as num?)?.toDouble(),
      flagSatuanBesar: json['Flag_Satuan_Besar'] as String?,
      colly1: (json['Colly1'] as num?)?.toDouble(),
      colly2: (json['Colly2'] as num?)?.toDouble(),
      hrsBudgeting: json['Hrs_Budgeting'] as String?,
    );

Map<String, dynamic> _$PaketToJson(Paket instance) => <String, dynamic>{
      'Kode_SO': instance.kodeSO,
      'Kode_Paket': instance.kodePaket,
      'Pakai_Range': instance.pakaiRange,
      'Diskon_Cash': instance.diskonCash,
      'Min_Order': instance.minOrder,
      'Pkt_2': instance.pkt2,
      'Max_Order': instance.maxOrder,
      'Flag_Satuan_Besar': instance.flagSatuanBesar,
      'Colly1': instance.colly1,
      'Colly2': instance.colly2,
      'Hrs_Budgeting': instance.hrsBudgeting,
    };
