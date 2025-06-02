import '../../mega_commons.dart';

extension MegaResponseExtension on MegaResponse {
  List<T> parseList<T>(T Function(Map<String, dynamic>) fromJson) {
    return List<T>.from(
      (data as List).map((item) => fromJson(item as Map<String, dynamic>)),
    );
  }
}
