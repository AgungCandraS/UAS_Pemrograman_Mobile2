import 'package:bisnisku/features/inventory/data/datasources/inventory_datasource.dart';
import 'package:bisnisku/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:bisnisku/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:bisnisku/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:bisnisku/services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>((
  ref,
) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return InventoryRemoteDataSourceImpl(supabaseService: supabaseService);
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final remoteDataSource = ref.watch(inventoryRemoteDataSourceProvider);
  return InventoryRepositoryImpl(remoteDataSource: remoteDataSource);
});
