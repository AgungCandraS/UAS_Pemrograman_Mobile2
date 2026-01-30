import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bisnisku/core/utils/logger.dart';

/// Manages real-time subscriptions
class RealtimeManager {
  final SupabaseClient _client;
  final Map<String, RealtimeChannel> _channels = {};

  RealtimeManager(this._client);

  /// Subscribe to a table with callback
  RealtimeChannel subscribe({
    required String channelName,
    required String table,
    required void Function(PostgresChangePayload) onData,
    PostgresChangeFilter? filter,
  }) {
    if (_channels.containsKey(channelName)) {
      AppLogger.warning('Channel $channelName already exists');
      return _channels[channelName]!;
    }

    final channel = _client.channel(channelName);

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          filter: filter,
          callback: onData,
        )
        .subscribe();

    _channels[channelName] = channel;
    AppLogger.info('Subscribed to channel: $channelName');

    return channel;
  }

  /// Unsubscribe from a channel
  Future<void> unsubscribe(String channelName) async {
    final channel = _channels.remove(channelName);
    if (channel != null) {
      await _client.removeChannel(channel);
      AppLogger.info('Unsubscribed from channel: $channelName');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    for (final channel in _channels.values) {
      await _client.removeChannel(channel);
    }
    _channels.clear();
    AppLogger.info('Unsubscribed from all channels');
  }

  /// Dispose the manager
  void dispose() {
    unsubscribeAll();
  }
}
