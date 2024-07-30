// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      json['clean'] as bool,
      (json['labels'] as List<dynamic>)
          .map((e) => Label.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['delete_labels'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'clean': instance.clean,
      'labels': instance.labels,
      'delete_labels': instance.deleteLabels,
    };

Label _$LabelFromJson(Map<String, dynamic> json) => Label(
      json['from'] as String?,
      json['name'] as String,
      json['color'] as String,
      json['description'] as String?,
    );

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      'from': instance.from,
      'name': instance.name,
      'color': instance.color,
      'description': instance.description,
    };
