import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'detail_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('library');

    return Scaffold(
      appBar: AppBar(title: const Text('Library Anda'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada game di library'));
          }

          final games = box.values.toList();
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                leading: Image.network(
                  game['thumbnail'],
                  width: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(game['title']),
                subtitle: Text('${game['genre']}\n${game['platform']}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => box.delete(game['id']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPage(gameId: game['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}