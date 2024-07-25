import 'dart:typed_data';

class ConversionUtils {
  static Uint8List? convertToBytes(String data) {
    try {
      List<int> intValues = data
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map(int.tryParse)
          .where((value) => value != null)
          .cast<int>()
          .toList();
      return Uint8List.fromList(intValues);
    } catch (e) {
      return null;
    }
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
