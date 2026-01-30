import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/features/integration/presentation/pages/accounting_categories_page.dart';
import 'package:bisnisku/features/integration/presentation/pages/admin_fees_page.dart';
import 'package:bisnisku/features/integration/presentation/pages/products_page.dart';

class IntegrationPage extends ConsumerWidget {
  const IntegrationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Integrasi Bisnis'),
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.category), text: 'Akuntansi'),
              Tab(icon: Icon(Icons.receipt), text: 'Fees Admin'),
              Tab(icon: Icon(Icons.inventory_2), text: 'Produk'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountingCategoriesPage(),
            AdminFeesPage(),
            ProductsPage(),
          ],
        ),
      ),
    );
  }
}
