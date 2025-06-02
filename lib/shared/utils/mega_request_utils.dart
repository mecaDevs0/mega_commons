import '../../mega_commons.dart';

class MegaRequestUtils {
  MegaRequestUtils._();

  static Future<void> load({
    required Function() action,
    Function(MegaResponse)? onError,
    Function()? onFinally,
  }) async {
    try {
      await action();
    } on MegaResponse catch (e) {
      if (onError != null) {
        await onError(e);
      } else {
        _showErrorMessage(e);
      }
    } finally {
      if (onFinally != null) {
        onFinally();
      }
    }
  }

  static void _showErrorMessage(MegaResponse e) {
    MegaSnackbar.showErroSnackBar(e.message!);
  }
}
