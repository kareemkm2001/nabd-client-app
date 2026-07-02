extension StringExtension on String {
  String ellipsis([int maxLength = 25]) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}