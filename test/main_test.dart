import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../voci_app/test/providers_test.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        myProvider.overrideWithValue('Hello World'),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Example'),
        ),
        body: const MyWidget(),
      ),
    );
  }
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myValue = ref.watch(myProvider);
    return Center(
      child: Text(myValue),
    );
  }
}