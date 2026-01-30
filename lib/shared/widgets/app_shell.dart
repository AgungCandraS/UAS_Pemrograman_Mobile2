import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  void _onDestinationSelected(int index) {
    if (index == widget.navigationShell.currentIndex) return;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, size: 24),
            selectedIcon: Icon(Icons.dashboard, size: 24),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined, size: 24),
            selectedIcon: Icon(Icons.storage, size: 24),
            label: 'Inventori',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, size: 24),
            selectedIcon: Icon(Icons.shopping_cart, size: 24),
            label: 'Penjualan',
          ),
          NavigationDestination(
            icon: Icon(Icons.money_outlined, size: 24),
            selectedIcon: Icon(Icons.money, size: 24),
            label: 'Keuangan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: 24),
            selectedIcon: Icon(Icons.person, size: 24),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
