import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../models/abbreviation.dart';
import '../models/models.dart';

class MegaDataCache {
  MegaDataCache._();

  static Future<void> initialize([String? subDir]) async {
    await Hive.initFlutter(subDir ?? 'mega');
    Hive.registerAdapter(AuthTokenAdapter());
    Hive.registerAdapter(EnvironmentUrlAdapter());
    Hive.registerAdapter(AbbreviationAdapter());
    Hive.registerAdapter(AddressAdapter());
    Hive.registerAdapter(ProfileTokenAdapter());
    Hive.registerAdapter(AppleModelAdapter());

    await openBox<AuthToken>();
    await openBox<EnvironmentUrl>();
    await openBox<Abbreviation>();
    await openBox<Address>();
    await openBox<ProfileToken>();
    await openBox<AppleModel>();
    await openBox<bool>();
    await openBox<String>();
    await openBox<List<String>>();
    await openBox<int>();
    await openBox<double>();
    await openBox<Map<String, dynamic>>();
  }

  static Future<void> openBox<T>() async {
    await Hive.openBox<T>(T.toString());
  }

  static Box<T> box<T>() {
    return Hive.box<T>(T.toString());
  }
}
