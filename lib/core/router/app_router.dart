import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bisnisku/features/auth/presentation/pages/splash_page.dart';
import 'package:bisnisku/features/auth/presentation/pages/login_page.dart';
import 'package:bisnisku/features/auth/presentation/pages/register_page.dart';
import 'package:bisnisku/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:bisnisku/features/home/presentation/pages/home_page.dart';
import 'package:bisnisku/features/finance/presentation/pages/finance_page.dart';
import 'package:bisnisku/features/finance/presentation/pages/transactions_page.dart';
import 'package:bisnisku/features/employees/presentation/pages/employee_page.dart';
import 'package:bisnisku/features/production/presentation/pages/production_page.dart';
import 'package:bisnisku/features/payroll/presentation/pages/payroll_page.dart';
import 'package:bisnisku/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:bisnisku/features/inventory/presentation/pages/add_edit_item_page.dart';
import 'package:bisnisku/features/sales/presentation/pages/sales_page.dart';
import 'package:bisnisku/features/sales/presentation/pages/new_sale_page.dart';
import 'package:bisnisku/features/profile/presentation/pages/profile_page.dart';
import 'package:bisnisku/features/integration/presentation/pages/integration_page.dart';
import 'package:bisnisku/features/reports/presentation/pages/reports_hub_page.dart';
import 'package:bisnisku/features/reports/presentation/pages/finance_report_page.dart';
import 'package:bisnisku/features/reports/presentation/pages/payroll_report_page.dart';
import 'package:bisnisku/features/reports/presentation/pages/production_report_page.dart';
import 'package:bisnisku/features/reports/presentation/pages/sales_report_page.dart';
import '../../shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Page not found'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/splash'),
            child: const Text('Back to Splash'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    // Auth Routes (no shell)
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // Main App Routes (with shell/bottom nav)
    // 5 main tabs in navbar: Home, Inventory, Orders, Finance, Profile
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: InventoryListPage()),
              routes: [
                GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: AddEditItemPage()),
                ),
                GoRoute(
                  path: 'item/:itemId',
                  pageBuilder: (context, state) {
                    final itemId = state.pathParameters['itemId'];
                    return MaterialPage(child: AddEditItemPage(itemId: itemId));
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sales',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SalesPage()),
              routes: [
                GoRoute(
                  path: 'new',
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: NewSalePage()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/finance',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FinancePage()),
              routes: [
                GoRoute(
                  path: 'transactions',
                  pageBuilder: (context, state) => const MaterialPage(
                    child: DefaultTabController(
                      length: 3,
                      child: TransactionsPage(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    ),

    // Standalone routes (not in bottom nav)
    GoRoute(
      path: '/employee',
      builder: (context, state) => const EmployeePage(),
    ),
    GoRoute(
      path: '/production',
      builder: (context, state) => const ProductionPage(),
    ),
    GoRoute(path: '/payroll', builder: (context, state) => const PayrollPage()),
    GoRoute(
      path: '/integration',
      builder: (context, state) => const IntegrationPage(),
    ),

    // Reports Routes
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsHubPage(),
    ),
    GoRoute(
      path: '/reports/finance',
      builder: (context, state) => const FinanceReportPage(),
    ),
    GoRoute(
      path: '/reports/payroll',
      builder: (context, state) => const PayrollReportPage(),
    ),
    GoRoute(
      path: '/reports/production',
      builder: (context, state) => const ProductionReportPage(),
    ),
    GoRoute(
      path: '/reports/sales',
      builder: (context, state) => const SalesReportPage(),
    ),
  ],
  observers: [HeroController()],
);
