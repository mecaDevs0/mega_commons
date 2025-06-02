import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

part 'abbreviation.g.dart';

@HiveType(typeId: 104)
enum Abbreviation {
  @HiveField(0)
  custom('C', 'development', 'CUSTOM'),
  @HiveField(1)
  development('D', 'development', 'DEV'),
  @HiveField(2)
  homolog('H', 'homolog', 'HML'),
  @HiveField(3)
  production('P', 'production', 'PROD');

  const Abbreviation(this.letter, this.firebase, this.name);
  final String letter;
  final String firebase;
  final String name;
}
