import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    try {
    final user = await ApiService().getUser(email);

    globalProfileId = user.userId;

    return await _supabase.auth.signInWithPassword(email:email, password: password);
  } catch (e) {
    throw Exception('Failed to sign in: $e');
  }
  }

  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    try {
    await ApiService().addUser(email, password);

    return await _supabase.auth.signUp(email: email, password: password);
  } catch (e) {
    throw Exception('Failed to sign up: $e');
  }
  }

  Future<void> signOut() async {
    globalProfileId = 0;
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}