import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  // UI-ın çağırdığı 'login' metodu
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
          () => _authRepository.signInWithEmailAndPassword(email, password),
    );
    return !state.hasError;
  }

  // UI-ın çağırdığı 'register' metodu
  Future<bool> register(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
          () => _authRepository.createUserWithEmailAndPassword(email, password),
    );
    return !state.hasError;
  }

  // UI-ın çağırdığı 'logout' metodu
  Future<bool> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
    return !state.hasError;
  }
}