import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_filters.freezed.dart';

@freezed
class ReportFilters with _$ReportFilters {
  const factory ReportFilters({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    String? category,
  }) = _ReportFilters;
}
