import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'chat.dart';

class PickReceiver extends StatefulWidget {
  const PickReceiver({super.key});

  @override
  State<PickReceiver> createState() => _PickReceiverState();
}

class _PickReceiverState extends State<PickReceiver> {
  late SupabaseStreamBuilder chat;
  final user = Supabase.instance.client.auth.currentUser!;
  late Future<List<dynamic>> receivers;

  //Функция чтения json файла
  Future<List<dynamic>> readFromSB() async {
    try {
      final res = await Supabase.instance.client
          .from('users')
          .select('id, email')
          .neq('id', user.id.toString());
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> checkMessages() async {
    try {
      if (user.email?.toLowerCase() != 'armagedji@gmail.com') {
        return [{'id': 'ef1c0bcc-4603-4348-967f-cc09f1b69e98',
                  'email': 'armagedji@gmail.com'}];
      }
      final res = await Supabase.instance.client
          .from('chat')
          .select(
              'id, sender_id, users!chat_user_set_id_fkey(id, email)') 
          .eq('receiver_id', 'ef1c0bcc-4603-4348-967f-cc09f1b69e98');
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    receivers = checkMessages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Выбор чата"),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
          future: receivers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("Пользователей нет.");
            }
            final receiver = snapshot.data as List<dynamic>;
            var uniqueReceivers = [];
            if (user.email?.toLowerCase() != 'armagedji@gmail.com') {
              uniqueReceivers = [
                {
                  'id': 'ef1c0bcc-4603-4348-967f-cc09f1b69e98',
                  'email': 'armagedji@gmail.com'
                }
              ];
              return Chat(
                receiver_username: uniqueReceivers[0]['email'].toString(),
                receiver_id: uniqueReceivers[0]['id'].toString(),
              );
            } else {
              uniqueReceivers = receiver.fold<List<dynamic>>([], (acc, item) {
                if (!acc.any((e) => e['id'] == item['id'])) {
                  acc.add({
                    'email': item['users']
                        ['email'],
                    'id': item['users']['id'], 
                  });
                }
                return acc;
              });
            }
            return ListView.builder(
                itemCount: uniqueReceivers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String username =
                              uniqueReceivers[index]['email'].toString();
                          String receiver_id =
                              uniqueReceivers[index]['id'].toString();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chat(
                                receiver_username: username,
                                receiver_id: receiver_id,
                              ),
                            ),
                          );
                        },
                        child: Text(uniqueReceivers[index]['email'],
                            style: const TextStyle(color: Colors.black)),
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
