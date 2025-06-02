import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';
import 'abbreviation.dart';

part 'environment_url.g.dart';

@HiveType(typeId: 101)
class EnvironmentUrl {
  EnvironmentUrl({
    required this.abbreviation,
    required this.name,
    required this.url,
  });
  static String envUrlBoxKey = 'envUrl';

  @HiveField(0)
  Abbreviation abbreviation;
  @HiveField(1)
  String name;
  @HiveField(2)
  String url;

  static Box<EnvironmentUrl> get envBox => MegaDataCache.box<EnvironmentUrl>();

  static Future<void> save(EnvironmentUrl environmentUrl) async {
    await envBox.put(envUrlBoxKey, environmentUrl);
  }

  Future<void> remove() async {
    await envBox.delete(envUrlBoxKey);
  }

  static EnvironmentUrl? fromCache() {
    return envBox.get(envUrlBoxKey);
  }

  static Future<void> toDev(String url) async {
    await save(
      EnvironmentUrl(
        abbreviation: Abbreviation.development,
        name: Abbreviation.development.name,
        url: url,
      ),
    );
  }

  static Future<void> toHomolog(String url) async {
    await save(
      EnvironmentUrl(
        abbreviation: Abbreviation.homolog,
        name: Abbreviation.homolog.name,
        url: url,
      ),
    );
  }

  static Future<void> toProduction(String url) async {
    await save(
      EnvironmentUrl(
        abbreviation: Abbreviation.production,
        name: Abbreviation.production.name,
        url: url,
      ),
    );
  }
}
