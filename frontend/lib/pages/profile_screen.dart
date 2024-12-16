import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/api/api_service.dart';
import 'package:flutter_market_alpha/components/profile.dart';
import 'package:flutter_market_alpha/main.dart';
import 'package:flutter_market_alpha/models/user.dart';
import '../auth/auth_service.dart';
import 'order_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await ApiService().getUser(authService.getCurrentUserEmail() ?? "");
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user: $error');
    }
  }

  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль'), actions: [
        IconButton(onPressed: logout, icon: const Icon(Icons.logout))
      ],),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('Не удалось загрузить данные пользователя'))
          : Column(
        children: [
          Profile(user: _user!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditProfilePage(user: _user!),
              //   ),
              // ).then((updatedUser) {
              //   if (updatedUser != null) {
              //     _updateData(updatedUser);
              //   }
              // });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(350, 40),
                textStyle: const TextStyle(
                  fontSize: 14,
                )),
            child: const Text('Редактировать профиль'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyOrders(userId: globalProfileId),
                ),
              );
            },
            child: Container(
              width: 350,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(129, 40, 0, 1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: const Center(
                child: Text('Мои заказы >>', style:
                  TextStyle(
                    color: Color.fromRGBO(129, 40, 0, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )
                ),
              ),
            ),
          )
          ],
      ),
    );
  }
}