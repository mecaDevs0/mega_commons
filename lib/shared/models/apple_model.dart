import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

part 'apple_model.g.dart';

@HiveType(typeId: 105)
class AppleModel {
  AppleModel({
    required this.givenName,
    required this.userIdentifier,
    required this.email,
  });
  @HiveField(0)
  final String givenName;
  @HiveField(1)
  final String userIdentifier;
  @HiveField(2)
  final String email;

  static Box<AppleModel> get envBox => MegaDataCache.box<AppleModel>();
  static const String _key = 'apple_login';

  Map<String, dynamic> toJson() => {
        'givenName': givenName,
        'userIdentifier': userIdentifier,
        'email': email,
      };

  static Future<void> save(AppleModel appleModel) async {
    await envBox.put(_key, appleModel);
  }

  static AppleModel? get fromCache {
    return envBox.get(_key);
  }

  static Future<void> remove() async {
    await envBox.delete(_key);
  }
}
