enum FileType { image, document, video, audio, archive, other }

class LocalFile {
  final String name;
  final String path;
  final int sizeBytes;
  final DateTime date;
  final FileType type;

  LocalFile({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.date,
    required this.type,
  });

  String get sizeString {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get dateString {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}