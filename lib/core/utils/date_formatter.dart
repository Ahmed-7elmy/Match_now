class DateFormatter {
  const DateFormatter._();

  static String short(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
