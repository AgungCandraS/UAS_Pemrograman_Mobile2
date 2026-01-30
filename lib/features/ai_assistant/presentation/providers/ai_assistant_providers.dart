import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bisnisku/services/ai_service.dart';

final aiServiceProvider = Provider<AiService>((ref) => AiService());
