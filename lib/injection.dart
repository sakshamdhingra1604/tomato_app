import 'package:get_it/get_it.dart';
import 'data/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // Auth Repository ko register kar rahe hain
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
}