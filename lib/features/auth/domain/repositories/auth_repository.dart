import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  UserEntity? getCurrentUser();
}