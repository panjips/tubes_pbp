import 'package:tubes_pbp/utils/date_picker/easy_text_styles.dart';
import 'package:flutter/material.dart';

import '../utils/date_picker/easy_date_formatter.dart';

/// Represents a header widget for displaying the date as `01/01/2023`.
class SelectedFullDateWidget extends StatelessWidget {
  const SelectedFullDateWidget({
    super.key,
    required this.date,
    required this.locale,
  });

  /// Represents the date for the month header.
  final DateTime date;

  /// A `String` that represents the locale code to use for formatting the month name in the header.
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Text(
      EasyDateFormatter.fullDateDMY(
        date,
        locale,
      ),
      style: EasyTextStyles.selectedDateStyle,
    );
  }
}
