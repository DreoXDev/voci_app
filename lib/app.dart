import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/routes/app_router.dart';
import 'package:voci_app/features/auth/domain/entities/user_entity.dart';

class App extends ConsumerWidget {
  final UserEntity? user;
  const App({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: appRouterProvider,
    );
  }
}