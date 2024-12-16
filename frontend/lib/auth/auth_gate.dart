import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/auth/auth_service.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:flutter_market_alpha/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../api/api_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  
    Future<void> checkIn() async {
    final email = AuthService().getCurrentUserEmail();
    final user = await ApiService().getUser(email ?? "");

    globalProfileId = user.userId;}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            checkIn();
            return MainPage();
          } else {
            return LoginPage();
          }
        });
  }
}
