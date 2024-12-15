# Практика 11 - Игошев М. Л. ЭФБО-02-22

## Создал страницы входа и регистрации

### Страница входа
<kbd>
<img src="https://github.com/user-attachments/assets/72709bbf-793d-485e-84d0-de423a4cb2c1" height="400">
</kbd>

### Страница регистрации 
<kbd>
<img src="https://github.com/user-attachments/assets/132e85b4-858b-4b15-b261-feda1c8cb618" height="400">
</kbd>

## Зарегистрировался в Supabase, настроил соединение с Supabase

### Подключение supabase
```
void main() async {
  // supabase setup
  await Supabase.initialize(
    anonKey: "secret_key",
    url: "https://hcvxcifkjapgklojwgvf.supabase.co",
  );
  runApp(MyApp());
}
```

### Функции для авторизации / выхода 

```
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email:email, password: password);
  }

  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(email:email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
```

## Настроил отображение почты в профиле
```
final authService = AuthService();
final currentEmail = authService.getCurrentUserEmail() ?? "Error!";
Text(currentEmail)
```
<kbd>
<img src="https://github.com/user-attachments/assets/9d79c4cc-dcea-4bf7-917f-bf564cbcf937" height="400">
</kbd>
