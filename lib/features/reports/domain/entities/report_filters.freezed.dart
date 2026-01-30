// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReportFilters {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReportFiltersCopyWith<ReportFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportFiltersCopyWith<$Res> {
  factory $ReportFiltersCopyWith(
          ReportFilters value, $Res Function(ReportFilters) then) =
      _$ReportFiltersCopyWithImpl<$Res, ReportFilters>;
  @useResult
  $Res call(
      {DateTime startDate, DateTime endDate, String? status, String? category});
}

/// @nodoc
class _$ReportFiltersCopyWithImpl<$Res, $Val extends ReportFilters>
    implements $ReportFiltersCopyWith<$Res> {
  _$ReportFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? status = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportFiltersImplCopyWith<$Res>
    implements $ReportFiltersCopyWith<$Res> {
  factory _$$ReportFiltersImplCopyWith(
          _$ReportFiltersImpl value, $Res Function(_$ReportFiltersImpl) then) =
      __$$ReportFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate, DateTime endDate, String? status, String? category});
}

/// @nodoc
class __$$ReportFiltersImplCopyWithImpl<$Res>
    extends _$ReportFiltersCopyWithImpl<$Res, _$ReportFiltersImpl>
    implements _$$ReportFiltersImplCopyWith<$Res> {
  __$$ReportFiltersImplCopyWithImpl(
      _$ReportFiltersImpl _value, $Res Function(_$ReportFiltersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? status = freezed,
    Object? category = freezed,
  }) {
    return _then(_$ReportFiltersImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ReportFiltersImpl implements _ReportFilters {
  const _$ReportFiltersImpl(
      {required this.startDate,
      required this.endDate,
      this.status,
      this.category});

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final String? status;
  @override
  final String? category;

  @override
  String toString() {
    return 'ReportFilters(startDate: $startDate, endDate: $endDate, status: $status, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportFiltersImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startDate, endDate, status, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportFiltersImplCopyWith<_$ReportFiltersImpl> get copyWith =>
      __$$ReportFiltersImplCopyWithImpl<_$ReportFiltersImpl>(this, _$identity);
}

abstract class _ReportFilters implements ReportFilters {
  const factory _ReportFilters(
      {required final DateTime startDate,
      required final DateTime endDate,
      final String? status,
      final String? category}) = _$ReportFiltersImpl;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  String? get status;
  @override
  String? get category;
  @override
  @JsonKey(ignore: true)
  _$$ReportFiltersImplCopyWith<_$ReportFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
