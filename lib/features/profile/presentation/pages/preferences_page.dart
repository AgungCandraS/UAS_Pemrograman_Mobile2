import 'package:bisnisku/core/utils/currency_formatter.dart';
import 'package:bisnisku/core/utils/datetime_formatter.dart';
import 'package:bisnisku/features/profile/application/providers/profile_providers.dart';
import 'package:bisnisku/features/profile/domain/entities/profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  const PreferencesPage({super.key});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _selectedLanguage = 'id';
  String _selectedTheme = 'system';
  String _selectedCurrency = 'IDR';
  String _selectedDateFormat = 'dd/MM/yyyy';
  String _selectedTimeFormat = '24h';
  bool _isLoading = false;

  final List<Map<String, String>> _languages = [
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'en', 'name': 'English'},
  ];

  final List<Map<String, String>> _themes = [
    {'code': 'system', 'name': 'Sistem', 'icon': '🖥️'},
    {'code': 'light', 'name': 'Terang', 'icon': '☀️'},
    {'code': 'dark', 'name': 'Gelap', 'icon': '🌙'},
  ];

  void _loadSettings(ProfileSettings? settings) {
    if (settings != null) {
      setState(() {
        _notificationsEnabled = settings.notificationsEnabled;
        _emailNotifications = settings.emailNotifications;
        _pushNotifications = settings.pushNotifications;
        _selectedLanguage = settings.language;
        _selectedTheme = settings.theme;
        _selectedCurrency = settings.currency;
        _selectedDateFormat = settings.dateFormat;
        _selectedTimeFormat = settings.timeFormat;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final settings = ProfileSettings(
        userId: userId,
        notificationsEnabled: _notificationsEnabled,
        emailNotifications: _emailNotifications,
        pushNotifications: _pushNotifications,
        language: _selectedLanguage,
        theme: _selectedTheme,
        currency: _selectedCurrency,
        dateFormat: _selectedDateFormat,
        timeFormat: _selectedTimeFormat,
      );

      await ref.read(updateSettingsProvider.notifier).updateSettings(settings);

      // Small delay to ensure database is updated
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        // Force invalidate to trigger fresh fetch
        ref.invalidate(profileSettingsProvider);

        // Also notify user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferensi berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(profileSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferensi'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _saveSettings),
        ],
      ),
      body: settingsAsync.when(
        data: (settings) {
          // Load data once
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (settings != null && _selectedLanguage != settings.language) {
              _loadSettings(settings);
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Notifikasi'),
                _buildNotificationSection(),
                const SizedBox(height: 24),
                _buildSectionTitle('Tampilan'),
                _buildDisplaySection(),
                const SizedBox(height: 24),
                _buildSectionTitle('Regional'),
                _buildRegionalSection(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Simpan Preferensi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications, color: Colors.blue),
            ),
            title: const Text('Aktifkan Notifikasi'),
            subtitle: const Text('Terima notifikasi dari aplikasi'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                if (!value) {
                  _emailNotifications = false;
                  _pushNotifications = false;
                }
              });
            },
          ),
          if (_notificationsEnabled) ...[
            const Divider(height: 1),
            SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.email, color: Colors.orange),
              ),
              title: const Text('Notifikasi Email'),
              subtitle: const Text('Terima notifikasi via email'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.phone_android, color: Colors.green),
              ),
              title: const Text('Push Notifications'),
              subtitle: const Text('Terima notifikasi push'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
              },
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDisplaySection() {
    return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.palette, color: Colors.purple),
                ),
                title: const Text('Tema'),
                subtitle: Text(_getThemeName(_selectedTheme)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language, color: Colors.indigo),
                ),
                title: const Text('Bahasa'),
                subtitle: Text(_getLanguageName(_selectedLanguage)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 100.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildRegionalSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.attach_money, color: Colors.teal),
            ),
            title: const Text('Mata Uang'),
            subtitle: Text(
              '$_selectedCurrency - ${CurrencyFormatter.getCurrencyInfo(_selectedCurrency)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCurrencyDialog(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.calendar_today, color: Colors.cyan),
            ),
            title: const Text('Format Tanggal'),
            subtitle: Text(_getDateFormatExample(_selectedDateFormat)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showDateFormatDialog(),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.schedule, color: Colors.pink),
            ),
            title: const Text('Format Waktu'),
            subtitle: Text(_getTimeFormatExample(_selectedTimeFormat)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTimeFormatDialog(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  String _getThemeName(String code) {
    return _themes.firstWhere((t) => t['code'] == code)['name']!;
  }

  String _getLanguageName(String code) {
    return _languages.firstWhere((l) => l['code'] == code)['name']!;
  }

  String _getDateFormatExample(String format) {
    final now = DateTime.now();
    return '${DateTimeFormatter.formatDate(now, format: format)} (${format.toUpperCase()})';
  }

  String _getTimeFormatExample(String format) {
    final now = DateTime.now();
    return '${DateTimeFormatter.formatTime(now, format: format)} (${format.toUpperCase()})';
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) {
            final isSelected = _selectedTheme == theme['code'];
            return InkWell(
              onTap: () {
                setState(() => _selectedTheme = theme['code']!);
                // Update theme IMMEDIATELY in app
                ref
                    .read(immediateThemeProvider.notifier)
                    .setTheme(theme['code']!);
                Navigator.pop(context);
                _saveSettings();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(theme['icon']!),
                    const SizedBox(width: 12),
                    Text(
                      theme['name']!,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            final isSelected = _selectedLanguage == language['code'];
            return InkWell(
              onTap: () {
                setState(() => _selectedLanguage = language['code']!);
                Navigator.pop(context);
                _saveSettings();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      language['name']!,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    final currencies = CurrencyFormatter.getSupportedCurrencies();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Mata Uang'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              final isSelected = _selectedCurrency == currency['code'];
              return InkWell(
                onTap: () {
                  setState(() => _selectedCurrency = currency['code']!);
                  Navigator.pop(context);
                  _saveSettings();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withValues(alpha: 0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: 2,
                          ),
                          color: isSelected ? Colors.blue : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currency['code']} - ${currency['symbol']}',
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              currency['name']!,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDateFormatDialog() {
    final dateFormats = DateTimeFormatter.getSupportedDateFormats();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Format Tanggal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: dateFormats.map((format) {
            final isSelected = _selectedDateFormat == format['code'];
            return InkWell(
              onTap: () {
                setState(() => _selectedDateFormat = format['code']!);
                Navigator.pop(context);
                _saveSettings();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            format['name']!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                          Text(
                            'Contoh: ${format['example']}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTimeFormatDialog() {
    final timeFormats = DateTimeFormatter.getSupportedTimeFormats();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Format Waktu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: timeFormats.map((format) {
            final isSelected = _selectedTimeFormat == format['code'];
            return InkWell(
              onTap: () {
                setState(() => _selectedTimeFormat = format['code']!);
                Navigator.pop(context);
                _saveSettings();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.1) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            format['name']!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                          Text(
                            'Contoh: ${format['example']}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
