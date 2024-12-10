import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Импортируем ImagePicker

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = "Иван Иванов";
  String email = "ivan@example.com";
  File? _image;

  final ImagePicker _picker = ImagePicker();

  // Функция для выбора изображения
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Функция для сохранения профиля
  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Сохранение изменений профиля (например, отправка на сервер)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Профиль сохранен')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Фотография профиля
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image == null
                        ? AssetImage('assets/profile_picture.png') as ImageProvider
                        : FileImage(_image!),
                  ),
                ),
                const SizedBox(height: 16),
                // Форма для редактирования профиля
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Имя
                      TextFormField(
                        initialValue: username,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSaved: (value) {
                          username = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email
                      TextFormField(
                        initialValue: email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSaved: (value) {
                          email = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Введите корректный email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Кнопка сохранения
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Сохранить'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
