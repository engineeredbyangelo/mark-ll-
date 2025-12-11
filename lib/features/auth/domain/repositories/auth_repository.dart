import '../entities/user.dart';

/// Authentication Repository Interface (Domain Layer)
/// Defines the contract for authentication operations
abstract class AuthRepository {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithGithub();
  Future<User?> signUpWithEmail(String email, String password, String displayName);
  Future<void> signOut();
  Future<User?> getCurrentUser();
  Stream<User?> get authStateChanges;
}
