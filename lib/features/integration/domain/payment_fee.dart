import 'package:equatable/equatable.dart';

/// Fee administrasi untuk marketplace/pembayaran
class PaymentFee extends Equatable {
  final String? id;
  final String productName; // e.g., "Belle", "K5"
  final String paymentType; // e.g., "marketplace", "cod", "transfer"
  final double feePercent; // Admin fee dalam persen (e.g., 2.5 untuk 2.5%)
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentFee({
    this.id,
    required this.productName,
    required this.paymentType,
    required this.feePercent,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentFee.fromJson(Map<String, dynamic> json) {
    return PaymentFee(
      id: json['id'] as String?,
      productName: json['product_name'] as String,
      paymentType: json['payment_type'] as String,
      feePercent: (json['fee_percent'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'product_name': productName,
      'payment_type': paymentType,
      'fee_percent': feePercent,
      if (notes != null) 'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PaymentFee copyWith({
    String? id,
    String? productName,
    String? paymentType,
    double? feePercent,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentFee(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      paymentType: paymentType ?? this.paymentType,
      feePercent: feePercent ?? this.feePercent,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productName,
    paymentType,
    feePercent,
    notes,
    createdAt,
    updatedAt,
  ];
}
