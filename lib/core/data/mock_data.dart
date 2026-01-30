import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StatCardData extends Equatable {
  const StatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.trend,
    required this.accent,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final double trend;
  final Color accent;

  @override
  List<Object?> get props => [title, value, subtitle, icon, trend, accent];
}

class InventoryItem extends Equatable {
  const InventoryItem({
    required this.name,
    required this.sku,
    required this.stock,
    required this.reorderLevel,
    required this.cost,
    required this.price,
  });

  final String name;
  final String sku;
  final int stock;
  final int reorderLevel;
  final double cost;
  final double price;

  bool get needsRestock => stock <= reorderLevel;

  @override
  List<Object?> get props => [name, sku, stock, reorderLevel, cost, price];
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.eta,
    required this.channel,
  });

  final String id;
  final String customer;
  final double amount;
  final String status;
  final DateTime eta;
  final String channel;

  String get etaLabel => DateFormat.MMMd().format(eta);

  @override
  List<Object?> get props => [id, customer, amount, status, eta, channel];
}

class Employee extends Equatable {
  const Employee({
    required this.name,
    required this.role,
    required this.salary,
    required this.active,
  });

  final String name;
  final String role;
  final double salary;
  final bool active;

  @override
  List<Object?> get props => [name, role, salary, active];
}

class PayrollRun extends Equatable {
  const PayrollRun({
    required this.period,
    required this.total,
    required this.headcount,
    required this.status,
  });

  final String period;
  final double total;
  final int headcount;
  final String status;

  @override
  List<Object?> get props => [period, total, headcount, status];
}

class FinanceSnapshot extends Equatable {
  const FinanceSnapshot({
    required this.revenue,
    required this.expense,
    required this.profit,
    required this.margin,
    required this.cash,
  });

  final double revenue;
  final double expense;
  final double profit;
  final double margin;
  final double cash;

  @override
  List<Object?> get props => [revenue, expense, profit, margin, cash];
}

final statCardsProvider = Provider<List<StatCardData>>((ref) {
  return const [
    StatCardData(
      title: 'Pendapatan',
      value: 'Rp 215 jt',
      subtitle: 'vs bulan lalu',
      icon: Icons.trending_up,
      trend: 0.12,
      accent: Color(0xFF2563EB),
    ),
    StatCardData(
      title: 'Laba Bersih',
      value: 'Rp 54 jt',
      subtitle: 'Margin 26%',
      icon: Icons.account_balance_wallet_outlined,
      trend: 0.08,
      accent: Color(0xFF16A34A),
    ),
    StatCardData(
      title: 'Kas & Likuiditas',
      value: 'Rp 88 jt',
      subtitle: 'Saldo kas saat ini',
      icon: Icons.savings_outlined,
      trend: 0.05,
      accent: Color(0xFF0EA5E9),
    ),
    StatCardData(
      title: 'Stok Rendah',
      value: '7 SKU',
      subtitle: 'Butuh restock',
      icon: Icons.inventory_2_outlined,
      trend: -0.03,
      accent: Color(0xFFEF4444),
    ),
  ];
});

final inventoryProvider = Provider<List<InventoryItem>>((ref) {
  return const [
    InventoryItem(
      name: 'Kopi Arabika 1kg',
      sku: 'BRW-001',
      stock: 24,
      reorderLevel: 15,
      cost: 95000,
      price: 155000,
    ),
    InventoryItem(
      name: 'Kemasan Standing Pouch',
      sku: 'PKG-014',
      stock: 340,
      reorderLevel: 200,
      cost: 1200,
      price: 2800,
    ),
    InventoryItem(
      name: 'Dripper V60',
      sku: 'BRW-112',
      stock: 12,
      reorderLevel: 10,
      cost: 78000,
      price: 149000,
    ),
    InventoryItem(
      name: 'Botol Kopi Susu 250ml',
      sku: 'PKG-055',
      stock: 76,
      reorderLevel: 80,
      cost: 1800,
      price: 3200,
    ),
    InventoryItem(
      name: 'Sirup Gula Aren',
      sku: 'ING-034',
      stock: 38,
      reorderLevel: 25,
      cost: 21500,
      price: 42000,
    ),
  ];
});

final ordersProvider = Provider<List<OrderItem>>((ref) {
  final now = DateTime.now();
  return [
    OrderItem(
      id: '#INV-2041',
      customer: 'PT Nusantara',
      amount: 12500000,
      status: 'Dikirim',
      eta: now.add(const Duration(days: 1)),
      channel: 'B2B',
    ),
    OrderItem(
      id: '#INV-2039',
      customer: 'Store Bandung',
      amount: 3200000,
      status: 'Siap Kirim',
      eta: now.add(const Duration(days: 2)),
      channel: 'Distributor',
    ),
    OrderItem(
      id: '#INV-2035',
      customer: 'Online Shopee',
      amount: 215000,
      status: 'Proses',
      eta: now.add(const Duration(days: 1)),
      channel: 'E-commerce',
    ),
    OrderItem(
      id: '#INV-2033',
      customer: 'Cafe Ria',
      amount: 870000,
      status: 'Dikirim',
      eta: now,
      channel: 'Retail',
    ),
  ];
});

final employeesProvider = Provider<List<Employee>>((ref) {
  return const [
    Employee(
      name: 'Aulia Pratama',
      role: 'Ops & Warehouse',
      salary: 5500000,
      active: true,
    ),
    Employee(
      name: 'Nadia Siregar',
      role: 'Finance & Tax',
      salary: 7200000,
      active: true,
    ),
    Employee(
      name: 'Rio Saputra',
      role: 'Sales Lead',
      salary: 6800000,
      active: true,
    ),
    Employee(
      name: 'Intan Lestari',
      role: 'CS & Fulfillment',
      salary: 5200000,
      active: true,
    ),
  ];
});

final payrollProvider = Provider<List<PayrollRun>>((ref) {
  return const [
    PayrollRun(
      period: 'Des 2025',
      total: 27200000,
      headcount: 9,
      status: 'Selesai',
    ),
    PayrollRun(
      period: 'Nov 2025',
      total: 26500000,
      headcount: 9,
      status: 'Selesai',
    ),
    PayrollRun(
      period: 'Okt 2025',
      total: 26100000,
      headcount: 8,
      status: 'Selesai',
    ),
  ];
});

final financeSnapshotProvider = Provider<FinanceSnapshot>((ref) {
  return const FinanceSnapshot(
    revenue: 215000000,
    expense: 161000000,
    profit: 54000000,
    margin: 0.255,
    cash: 88000000,
  );
});
