import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Максим",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 22),
                    Text(
                      "+7 900 800-55-33",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(137, 138, 141, 100),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "email@gmail.com",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(137, 138, 141, 100),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/order.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Мои заказы",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/cards.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Медицинские карты",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/adress.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Мои адреса",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/settings.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Настройки",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  Text(
                    "Ответы на вопросы",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Политика конфиденциальности",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Пользовательское соглашение",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Выход",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(253, 53, 53, 100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
