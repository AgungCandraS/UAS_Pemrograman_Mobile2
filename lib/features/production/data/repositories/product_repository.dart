import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/product_model.dart';

class ProductRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'products';

  Future<List<Product>> fetchActiveProducts() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('is_active', true)
          .order('name');

      return (response as List<dynamic>)
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
