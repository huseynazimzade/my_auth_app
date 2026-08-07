import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// İstifadəçinin daxil olub-olmadığını canlı izləyən Stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final authControllerProvider = Provider((ref) => AuthController(ref));

class AuthController {
  final Ref _ref;
  AuthController(this._ref);

  Future<void> signUp(String email, String password) async {
    await _ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
  }

  Future<void> signIn(String email, String password) async {
    await _ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
          email: email,
          password: password,
        );
  }

  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOut();
  }
}