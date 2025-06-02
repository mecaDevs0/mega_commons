// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

part 'auth_token.g.dart';

@JsonSerializable()
@HiveType(typeId: 100)
class AuthToken {
  AuthToken({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.expires,
    this.expiresType,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
  static String cacheBoxKey = 'token';

  @HiveField(0)
  @JsonKey(name: 'access_token')
  String? accessToken;
  @HiveField(1)
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @HiveField(2)
  @JsonKey(name: 'expires_in')
  int? expiresIn;
  @HiveField(3)
  String? expires;
  @HiveField(4)
  @JsonKey(name: 'expires_type')
  String? expiresType;
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  static Box<AuthToken> get cacheBox => MegaDataCache.box<AuthToken>();

  Future<void> save() async {
    await cacheBox.put(cacheBoxKey, this);
  }

  static Future<void> remove() async {
    await cacheBox.delete(cacheBoxKey);
  }

  static AuthToken? fromCache() {
    return cacheBox.get(cacheBoxKey);
  }
}
