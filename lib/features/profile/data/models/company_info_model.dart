import 'package:bisnisku/features/profile/domain/entities/company_info.dart';

/// Company info model
class CompanyInfoModel extends CompanyInfo {
  const CompanyInfoModel({
    required super.userId,
    super.legalName,
    super.taxId,
    super.businessType,
    super.industry,
    super.address,
    super.city,
    super.province,
    super.postalCode,
    super.country,
    super.website,
    super.description,
    super.establishedDate,
    super.updatedAt,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    return CompanyInfoModel(
      userId: json['user_id'] as String,
      legalName: json['legal_name'] as String?,
      taxId: json['tax_id'] as String?,
      businessType: json['business_type'] as String?,
      industry: json['industry'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String? ?? 'Indonesia',
      website: json['website'] as String?,
      description: json['description'] as String?,
      establishedDate: json['established_date'] != null
          ? DateTime.parse(json['established_date'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'legal_name': legalName,
      'tax_id': taxId,
      'business_type': businessType,
      'industry': industry,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'country': country,
      'website': website,
      'description': description,
      'established_date': establishedDate?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  CompanyInfoModel copyWith({
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
    return CompanyInfoModel(
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
