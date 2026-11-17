import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '-';
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('library');

    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 24),
            FutureBuilder<String>(
              future: getEmail(),
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Email:'), Text(snapshot.data ?? '')],
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Games Dimiliki:'),
                    Text('${box.length}'),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => logout(context),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}