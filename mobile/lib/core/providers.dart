import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mens_wellness_mobile/core/api/api_client.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => throw StateError(
    'ApiClient must be provided for an authenticated route.',
  ),
);
