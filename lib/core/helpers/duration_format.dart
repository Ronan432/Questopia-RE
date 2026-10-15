import '../l10n/app_localizations.dart';

/// Formats a play duration for display.
///
/// The result is assembled from localized pieces so each locale keeps its own
/// unit labels ("2 h 15 min", "2 ч 15 мин"). Durations below one minute are
/// shown in seconds, and anything at or above an hour switches to hours plus
/// minutes so the string never grows past two units.
String formatPlayDuration(AppLocalizations l10n, Duration duration) {
  final totalSeconds = duration.inSeconds;
  if (totalSeconds <= 0) return l10n.durationSeconds(0);

  if (totalSeconds < 60) {
    return l10n.durationSeconds(totalSeconds);
  }

  final totalMinutes = duration.inMinutes;
  if (totalMinutes < 60) {
    return l10n.durationMinutes(totalMinutes);
  }

  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return l10n.durationHoursMinutes(hours, minutes);
}

/// Formats a timestamp as a short absolute date for the play statistics row.
///
/// Keeping the raw day, month and year avoids an `intl` date pattern lookup and
/// stays readable in both shipped locales.
String formatLastPlayedDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
