import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Config {
  final bool clean;
  final List<Label> labels;
  final List<String> deleteLabels;

  Config(this.clean, this.labels, this.deleteLabels);

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Label {
  final String? from;
  final String name, color;
  final String? description;

  Label(this.from, this.name, this.color, this.description);
  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  bool matches(Map<String, dynamic> apiLabel) {
    return name == apiLabel["name"] &&
        color == apiLabel["color"] &&
        (description == null || description == apiLabel["description"]);
  }
}
