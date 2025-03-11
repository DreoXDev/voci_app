import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/features/homeless/data/providers.dart';
import 'package:voci_app/features/homeless/domain/usecases/get_homeless.dart';

final getHomelessProvider = Provider((ref) {
  return GetHomeless(ref.watch(homelessRepositoryProvider));
});