import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voci_app/core/routes/app_router.dart';

// This is the provider that will provide the router
final routerProvider = appRouterProvider;

// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);