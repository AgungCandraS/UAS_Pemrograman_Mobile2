import 'package:equatable/equatable.dart';

/// Company information entity
class CompanyInfo extends Equatable {
  final String userId;
  final String? legalName;
  final String? taxId; // NPWP
  final String? businessType;
  final String? industry;
  final String? address;
  final String? city;
  final String? province;
  final String? postalCode;
  final String? country;
  final String? website;
  final String? description;
  final DateTime? establishedDate;
  final DateTime? updatedAt;

  const CompanyInfo({
    required this.userId,
    this.legalName,
    this.taxId,
    this.businessType,
    this.industry,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.country = 'Indonesia',
    this.website,
    this.description,
    this.establishedDate,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    legalName,
    taxId,
    businessType,
    industry,
    address,
    city,
    province,
    postalCode,
    country,
    website,
    description,
    establishedDate,
    updatedAt,
  ];

  CompanyInfo copyWith({
    String? userId,
    String? legalName,
    String? taxId,
    String? businessType,
    String? industry,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    String? country,
    String? website,
    String? description,
    DateTime? establishedDate,
    DateTime? updatedAt,
  }) {
    return CompanyInfo(
      userId: userId ?? this.userId,
      legalName: legalName ?? this.legalName,
      taxId: taxId ?? this.taxId,
      businessType: businessType ?? this.businessType,
      industry: industry ?? this.industry,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      website: website ?? this.website,
      description: description ?? this.description,
      establishedDate: establishedDate ?? this.establishedDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
