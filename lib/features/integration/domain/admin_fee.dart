import 'package:equatable/equatable.dart';

/// Admin fees untuk berbagai sales channel
/// Bisa diedit: persen admin dan biaya pemrosesan tetap
/// Bisa aktif/non-aktif per channel
class AdminFee extends Equatable {
  final String? id;
  final String salesChannel; // e.g., "Marketplace", "Direct Sale", "Wholesale"
  final double feePercent; // Persen admin fee (e.g., 2.5 untuk 2.5%)
  final double processingFee; // Biaya pemrosesan tetap (e.g., 1500 Rp)
  final bool isActive; // Channel aktif atau tidak
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminFee({
    this.id,
    required this.salesChannel,
    required this.feePercent,
    required this.processingFee,
    this.isActive = true,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminFee.fromJson(Map<String, dynamic> json) {
    return AdminFee(
      id: json['id'] as String?,
      salesChannel: json['sales_channel'] as String,
      feePercent: (json['fee_percent'] as num).toDouble(),
      processingFee: (json['processing_fee'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      'sales_channel': salesChannel,
      'fee_percent': feePercent,
      'processing_fee': processingFee,
      'is_active': isActive,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdminFee copyWith({
    String? id,
    String? salesChannel,
    double? feePercent,
    double? processingFee,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminFee(
      id: id ?? this.id,
      salesChannel: salesChannel ?? this.salesChannel,
      feePercent: feePercent ?? this.feePercent,
      processingFee: processingFee ?? this.processingFee,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    salesChannel,
    feePercent,
    processingFee,
    isActive,
    notes,
    createdAt,
    updatedAt,
  ];
}
