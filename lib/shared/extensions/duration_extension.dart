extension DurationExtension on Duration {
  String toHHmmss() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    final hour = twoDigits(inHours);
    return "${hour == '00' ? '' : '$hour:'}$twoDigitMinutes:$twoDigitSeconds";
  }
}
