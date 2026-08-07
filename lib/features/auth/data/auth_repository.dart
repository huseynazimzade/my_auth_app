import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-poçt ünvanına aid hesab tapılmadı.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-poçt və ya şifrə yanlışdır.';
      case 'email-already-in-use':
        return 'Bu e-poçt ünvanı artıq istifadə olunur.';
      case 'weak-password':
        return 'Şifrə çox zəifdir. Ən azı 6 simvol daxil edin.';
      case 'network-request-failed':
        return 'Şəbəkə xətası! İnternet bağlantınızı yoxlayın.';
      default:
        return e.message ?? 'Bilinməyən xəta baş verdi.';
    }
  }
}