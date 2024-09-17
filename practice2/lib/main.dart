import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ЭФБО-02-22',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [

            const SizedBox(height: 70),

            const Text('Авторизация',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 100),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: TextField(decoration: InputDecoration(hintText: 'Логин', filled: true, hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 10),
              child: TextField(decoration: InputDecoration(hintText: 'Пароль', filled: true, hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              ),
              ),
            ),

            SizedBox(width: 250, height: 50,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Запомнить меня', style: TextStyle(color: Colors.grey),), 
                value: false, 
                onChanged: (value) => {},
                ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
              child: SizedBox(width: double.infinity,
                child: ElevatedButton(onPressed: (){},
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide.none
    )
  )
), child: const Text('Войти', style: TextStyle(color: Colors.white),)
              ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
              child: SizedBox(width: double.infinity,
                child: ElevatedButton(onPressed: (){},
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: const BorderSide(color: Colors.blue)
    )
  )
), child: const Text('Регистрация', style: TextStyle(color: Colors.blue),)
              ),
              ),
            ),

            TextButton(onPressed: (){}, child: const Text('Восстановить пароль', style: TextStyle(color: Colors.grey)),)

          ],
        ),
    );
  }
}