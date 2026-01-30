/// Constants untuk modul sales
/// Setelah perbaikan relasi database, tidak perlu mapping lagi!

/// List channel yang valid (dari tabel marketplace_channels)
const List<String> VALID_MARKETPLACE_CHANNELS = [
  'Offline',
  'TikTok Shop',
  'Shopee',
  'Lazada',
  'Instagram',
];

/// Display name dengan icon untuk UI
const Map<String, String> CHANNEL_DISPLAY_WITH_ICON = {
  'Offline': '🏪 Toko Offline',
  'TikTok Shop': '📱 TikTok Shop',
  'Shopee': '🛍️ Shopee',
  'Lazada': '🏬 Lazada',
  'Instagram': '📸 Instagram',
};

/// Value untuk offline sale
const String CHANNEL_OFFLINE = 'Offline';

/// Sale types
const String SALE_TYPE_OFFLINE = 'offline';
const String SALE_TYPE_ONLINE = 'online';
