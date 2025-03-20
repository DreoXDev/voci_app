import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await remoteDataSource.signInWithEmailAndPassword(email, password);
    return _mapUserCredentialToUserEntity(userCredential);
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await remoteDataSource.createUserWithEmailAndPassword(email, password);
    return _mapUserCredentialToUserEntity(userCredential);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  UserEntity? getCurrentUser() {
    final firebaseUser = remoteDataSource.getCurrentUser();
    return firebaseUser != null ? _mapFirebaseUserToUserEntity(firebaseUser) : null;
  }

  UserEntity _mapUserCredentialToUserEntity(UserCredential userCredential) {
    return _mapFirebaseUserToUserEntity(userCredential.user!);
  }

  UserEntity _mapFirebaseUserToUserEntity(User firebaseUser) {
    return UserEntity(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
    );
  }
}