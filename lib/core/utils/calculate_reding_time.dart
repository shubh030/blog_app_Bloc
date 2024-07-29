int calculateReadingTime(String content) {
  final worldCount = content.split(RegExp(r'\s+')).length;

  final readingTime = worldCount / 225;

  return readingTime.ceil();
}
