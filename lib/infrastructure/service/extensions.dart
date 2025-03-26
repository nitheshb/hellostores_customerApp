extension Time on DateTime {
  DateTime get withoutTime => DateTime(year, month, day);
}

extension Parse on String? {
  double? get toDouble => double.tryParse(this?.replaceAll(',', '') ?? '');
}
