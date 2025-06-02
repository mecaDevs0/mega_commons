import 'package:json_annotation/json_annotation.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

part 'profile_token.g.dart';

@JsonSerializable(includeIfNull: false)
@HiveType(typeId: 103)
class ProfileToken {
  ProfileToken({
    this.fullName,
    this.email,
    this.password,
    this.refreshToken,
    this.providerId,
    this.typeProvider,
  });

  factory ProfileToken.fromJson(Map<String, dynamic> json) {
    return _$ProfileTokenFromJson(json);
  }
  static String profileTokenBoxKey = 'profileToken';

  @HiveField(0)
  String? fullName;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? password;
  @HiveField(3)
  String? refreshToken;
  @HiveField(4)
  String? providerId;
  @HiveField(5)
  int? typeProvider;

  Map<String, dynamic> toJson() => _$ProfileTokenToJson(this);

  static Box<ProfileToken> get profileBox => MegaDataCache.box<ProfileToken>();

  static Future<void> remove() async {
    await profileBox.delete(profileTokenBoxKey);
  }

  static ProfileToken? fromCache() {
    return profileBox.get(profileTokenBoxKey);
  }

  static Future<void> save(ProfileToken profileToken) async {
    await profileBox.put(profileTokenBoxKey, profileToken);
  }
}
