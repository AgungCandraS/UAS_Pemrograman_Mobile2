/// Supabase Configuration Constants
///
/// IMPORTANT: Replace these with your actual Supabase project credentials
/// Get them from: https://app.supabase.com/project/_/settings/api
class SupabaseConstants {
  // TODO: Replace with your Supabase URL
  static const String supabaseUrl = 'https://nccjlnguqoyjxkpstpgm.supabase.co';

  // TODO: Replace with your Supabase Anon Key
  static const String supabaseAnonKey = 'sb_publishable_cwALuXelfmdFvuKC7IEtxg_YCqZi1nU';

  // Auth redirect URLs
  static const String authCallbackUrlHostname = 'login-callback';

  // Storage bucket names
  static const String profileImagesBucket = 'profile-images';
  static const String productImagesBucket = 'product-images';

  // Table names
  static const String usersTable = 'users';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String transactionsTable = 'transactions';
  static const String employeesTable = 'employees';
}
