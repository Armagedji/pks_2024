# Практика 12 - Игошев М. Л. ЭФБО-02-22

## Привязка Supabase к базе данных

При регистрации или входе в аккаунт на устройстве будет сохраняться id пользователя, по нему из базы данных будут загружаться данные.

```
Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    try {
    final user = await ApiService().getUser(email);

    globalProfileId = user.userId; //Сохранение пользователя

    return await _supabase.auth.signInWithPassword(email:email, password: password);
  } catch (e) {
    throw Exception('Failed to sign in: $e');
  }
  }
```

## Фильтрация и сортировка

Была добавлена фильтрация и сортировка продуктов (по имени и цене), а также поиск.

### Поиск по названию (регистр не важен)
<kbd>
<img src="https://github.com/user-attachments/assets/4d41c2c6-df48-40d8-a9c8-1f3d3ff3ec9f" height="400">
</kbd>

### Фильтрация 
<kbd>
<img src="https://github.com/user-attachments/assets/177438a9-f25e-4030-adc7-70ce96b274d5" height="400">
</kbd>

### Фильтрация по цене
<kbd>
<img src="https://github.com/user-attachments/assets/9ea03712-78d6-48ee-9653-0b0972af06b8" height="400">
</kbd>

### Фильтрация по названию
<kbd>
<img src="https://github.com/user-attachments/assets/6cb923c9-6bf4-44d5-8498-a3c1b7ca9776" height="400">
</kbd>

### Поиск по цене
<kbd>
<img src="https://github.com/user-attachments/assets/065be25b-11a7-4597-bc98-52e91dfeb23f" height="400">
</kbd>
