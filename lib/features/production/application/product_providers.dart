import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/product_repository.dart';
import '../domain/product_model.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final activeProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchActiveProducts();
});
