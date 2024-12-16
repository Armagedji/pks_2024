import 'package:flutter/material.dart';
import 'package:flutter_market_alpha/auth/auth_gate.dart';
import 'package:flutter_market_alpha/pages/favorite_page.dart';
import 'package:flutter_market_alpha/pages/profile_screen.dart';
import 'package:flutter_market_alpha/pages/shopping_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';

void main() async {
  // supabase setup
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhjdnhjaWZramFwZ2tsb2p3Z3ZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyODEzNjIsImV4cCI6MjA0OTg1NzM2Mn0.4-nBYgbKXzXjJjgpj4Xbj7-fJb4KeRop0K2vRcrqnls",
    url: "https://hcvxcifkjapgklojwgvf.supabase.co",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Компьютерные игры',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(color: Colors.blue),
            unselectedItemColor: Colors.black,
            selectedItemColor:
                Colors.blue,
            unselectedLabelStyle: TextStyle(
                color: Colors.black),
            selectedLabelStyle: TextStyle(color: Colors.blue),
          )),
      home: const AuthGate(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0; 

  static List<Widget> widgetOptions = <Widget>[
    HomePage(),
    const FavoritePage(),
    const ShoppingPage(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ));
  }
}


int globalProfileId = 0;