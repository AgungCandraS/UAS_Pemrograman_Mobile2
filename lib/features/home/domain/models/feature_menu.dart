import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model untuk menu fitur di home
class FeatureMenu extends Equatable {
  const FeatureMenu({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
    this.badge,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
  final String? badge;

  @override
  List<Object?> get props => [id, title, subtitle, icon, route, color, badge];
}

/// Data statis untuk menu fitur
class FeatureMenuData {
  static List<FeatureMenu> get allMenus => [
    const FeatureMenu(
      id: 'employee',
      title: 'Manajemen\nKaryawan',
      subtitle: 'Data karyawan',
      icon: Icons.people_outlined,
      route: '/employee',
      color: Color(0xFF2563EB),
    ),
    const FeatureMenu(
      id: 'production',
      title: 'Pencatatan\nProduksi',
      subtitle: 'Catat produksi',
      icon: Icons.build_outlined,
      route: '/production',
      color: Color(0xFFF97316),
    ),
    const FeatureMenu(
      id: 'salary',
      title: 'Penggajian',
      subtitle: 'Gaji & tunjangan',
      icon: Icons.wallet_outlined,
      route: '/payroll',
      color: Color(0xFF16A34A),
    ),
    const FeatureMenu(
      id: 'report',
      title: 'Laporan',
      subtitle: 'Analisis bisnis',
      icon: Icons.trending_up_outlined,
      route: '/reports',
      color: Color(0xFF0EA5E9),
    ),
  ];
}
