String cleanHtml(String? text) {
  if (text == null || text.isEmpty) return '';
  return text
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}