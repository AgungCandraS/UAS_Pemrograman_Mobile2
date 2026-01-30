import 'dart:async';

class AiService {
  Future<String> askAssistant(String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'Berikut ide cepat: fokus pada SKU high-margin, jadwalkan batch pengiriman jam 14.00, dan siapkan promo bundling akhir pekan.';
  }
}

