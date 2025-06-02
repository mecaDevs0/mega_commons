import 'package:json_annotation/json_annotation.dart';

part 'mega_file.g.dart';

@JsonSerializable()
class MegaFile {

  MegaFile({
    this.fileName,
    this.filePath,
    this.fileNames,
  });

  factory MegaFile.fromJson(Map<String, dynamic> json) =>
      _$MegaFileFromJson(json);
  final String? fileName;
  final String? filePath;
  final List<String>? fileNames;
  Map<String, dynamic> toJson() => _$MegaFileToJson(this);
}
